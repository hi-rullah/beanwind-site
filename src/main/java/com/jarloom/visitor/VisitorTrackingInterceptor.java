package com.jarloom.visitor;

import java.net.InetAddress;
import java.security.Principal;
import java.time.Duration;
import java.util.Arrays;
import java.util.UUID;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * Logs one line per page view (not for css/js/fonts/images), e.g. for counting visits with CloudWatch Logs Insights:
 * {@code page_view method=GET path=/about status=200 visitor=- user=- ip=203.0.113.0 referer="..." ua="..."}.
 *
 * <p>The IP address is anonymized before it is logged. A visitor ID cookie is only set after the visitor accepted
 * analytics cookies in the cookie banner (cookie {@code jl_consent=accepted}, set by js/layout/consent.js);
 * after "rejected" an existing visitor cookie is deleted. See the /privacy page.
 */
public class VisitorTrackingInterceptor implements HandlerInterceptor {

    private static final Logger log = LoggerFactory.getLogger("visitor");

    static final String CONSENT_COOKIE = "jl_consent";
    static final String VISITOR_COOKIE = "jl_visitor";
    private static final Duration VISITOR_COOKIE_AGE = Duration.ofDays(180);
    private static final String VISITOR_ATTRIBUTE = VisitorTrackingInterceptor.class.getName() + ".visitor";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        if (handler instanceof HandlerMethod) {
            // Cookies must be set before the response body is written
            request.setAttribute(VISITOR_ATTRIBUTE, visitorId(request, response));
        }
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        if (!(handler instanceof HandlerMethod)) {
            return; // static resources
        }
        boolean errorDispatch = request.getDispatcherType() == DispatcherType.ERROR;
        if (ex != null && !errorDispatch) {
            return; // the container forwards to /error next; that dispatch logs the request with its real status
        }
        // For /error, log the page that failed (e.g. path=/missing status=404), not "/error"
        String path = errorDispatch ? (String) request.getAttribute(RequestDispatcher.ERROR_REQUEST_URI) : request.getRequestURI();
        Object status = errorDispatch ? request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE) : response.getStatus();

        Principal user = request.getUserPrincipal();
        log.info("page_view method={} path={} status={} visitor={} user={} ip={} referer=\"{}\" ua=\"{}\"",
                request.getMethod(),
                clean(path),
                status,
                orDash((String) request.getAttribute(VISITOR_ATTRIBUTE)),
                user == null ? "-" : clean(user.getName()),
                anonymizeIp(clientIp(request)),
                clean(request.getHeader(HttpHeaders.REFERER)),
                clean(request.getHeader(HttpHeaders.USER_AGENT)));
    }

    /** Returns the visitor ID when analytics cookies are accepted, otherwise null (and removes an old visitor cookie). */
    private String visitorId(HttpServletRequest request, HttpServletResponse response) {
        String consent = cookieValue(request, CONSENT_COOKIE);
        String visitor = cookieValue(request, VISITOR_COOKIE);

        if ("accepted".equals(consent)) {
            if (isUuid(visitor)) {
                return visitor;
            }
            String newVisitor = UUID.randomUUID().toString();
            response.addHeader(HttpHeaders.SET_COOKIE, visitorCookie(newVisitor, VISITOR_COOKIE_AGE));
            return newVisitor;
        }
        if (visitor != null) {
            response.addHeader(HttpHeaders.SET_COOKIE, visitorCookie("", Duration.ZERO));
        }
        return null;
    }

    private static String visitorCookie(String value, Duration maxAge) {
        // Secure is fine on http://localhost too: browsers treat localhost as a secure context
        return ResponseCookie.from(VISITOR_COOKIE, value)
                .httpOnly(true)
                .secure(true)
                .sameSite("Lax")
                .path("/")
                .maxAge(maxAge)
                .build()
                .toString();
    }

    private static String cookieValue(HttpServletRequest request, String name) {
        if (request.getCookies() == null) {
            return null;
        }
        return Arrays.stream(request.getCookies())
                .filter(cookie -> cookie.getName().equals(name))
                .map(Cookie::getValue)
                .findFirst()
                .orElse(null);
    }

    private static boolean isUuid(String value) {
        if (value == null) {
            return false;
        }
        try {
            UUID.fromString(value);
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    /** Behind a proxy (e.g. the Lambda Function URL) the visitor's address is the first X-Forwarded-For entry. */
    private static String clientIp(HttpServletRequest request) {
        String forwarded = request.getHeader("X-Forwarded-For");
        if (forwarded != null && !forwarded.isBlank()) {
            return forwarded.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }

    /** Keeps only the network part: IPv4 /24 (203.0.113.57 → 203.0.113.0), IPv6 /48. */
    static String anonymizeIp(String ip) {
        if (ip == null) {
            return "-";
        }
        try {
            // ofLiteral only parses IP literals, it never does a DNS lookup
            byte[] address = InetAddress.ofLiteral(ip).getAddress();
            Arrays.fill(address, address.length == 4 ? 3 : 6, address.length, (byte) 0);
            return InetAddress.getByAddress(address).getHostAddress();
        } catch (Exception e) {
            return "-";
        }
    }

    /** Header values come from the client: drop quotes and control characters so they cannot fake log lines. */
    private static String clean(String value) {
        if (value == null || value.isBlank()) {
            return "-";
        }
        String cleaned = value.replaceAll("[\\p{Cntrl}\"]", "");
        return cleaned.length() > 200 ? cleaned.substring(0, 200) : cleaned;
    }

    private static String orDash(String value) {
        return value == null ? "-" : value;
    }
}
