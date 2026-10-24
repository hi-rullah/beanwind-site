package com.beanwind.security;

import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;
import java.util.Base64;
import java.util.List;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.DeferredSecurityContext;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpRequestResponseHolder;
import org.springframework.security.web.context.SecurityContextRepository;

/**
 * Keeps the signed-in user in a signed cookie ({@value #COOKIE}) instead of the HTTP session.
 *
 * <p>Why: an HTTP session lives in one server's memory. With more than one instance, a request that reaches another
 * instance does not know the session, and the user randomly appears signed out. A cookie travels with every request,
 * so any instance can read it.
 *
 * <p>Cookie value: {@code base64url(expiresAt \n authorities \n username) "." base64url(HMAC-SHA256)}.
 * The content is readable by the user, not secret; the HMAC (keyed with {@code auth.cookie-secret}) proves that
 * this server issued it, so it cannot be edited or forged. Valid for {@link #VALIDITY} or until the browser is closed.
 */
public class SignedCookieSecurityContextRepository implements SecurityContextRepository {

    public static final String COOKIE = "bw_auth";
    private static final Duration VALIDITY = Duration.ofHours(8);
    private static final String HMAC = "HmacSHA256";

    private static final Base64.Encoder ENCODER = Base64.getUrlEncoder().withoutPadding();
    private static final Base64.Decoder DECODER = Base64.getUrlDecoder();

    private final SecretKeySpec key;

    public SignedCookieSecurityContextRepository(byte[] secret) {
        this.key = new SecretKeySpec(secret, HMAC);
    }

    @Override
    public DeferredSecurityContext loadDeferredContext(HttpServletRequest request) {
        Authentication authentication = read(cookieValue(request));
        return new DeferredSecurityContext() {
            @Override
            public SecurityContext get() {
                SecurityContext context = SecurityContextHolder.createEmptyContext();
                context.setAuthentication(authentication);
                return context;
            }

            @Override
            public boolean isGenerated() {
                return authentication == null;
            }
        };
    }

    /** Deprecated in the interface but still abstract; Spring Security itself calls {@link #loadDeferredContext}. */
    @Override
    @Deprecated
    public SecurityContext loadContext(HttpRequestResponseHolder requestResponseHolder) {
        return loadDeferredContext(requestResponseHolder.getRequest()).get();
    }

    /** Called after a successful sign-in (and with an empty context to sign out). */
    @Override
    public void saveContext(SecurityContext context, HttpServletRequest request, HttpServletResponse response) {
        Authentication authentication = context.getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            if (containsContext(request)) {
                response.addHeader(HttpHeaders.SET_COOKIE, cookie("", Duration.ZERO));
            }
            return;
        }
        response.addHeader(HttpHeaders.SET_COOKIE, cookie(write(authentication), null));
    }

    @Override
    public boolean containsContext(HttpServletRequest request) {
        return cookieValue(request) != null;
    }

    private String write(Authentication authentication) {
        String authorities = String.join(",", AuthorityUtils.authorityListToSet(authentication.getAuthorities()));
        String expiresAt = String.valueOf(Instant.now().plus(VALIDITY).getEpochSecond());
        String payload = ENCODER.encodeToString(
                String.join("\n", expiresAt, authorities, authentication.getName()).getBytes(StandardCharsets.UTF_8));
        return payload + "." + ENCODER.encodeToString(hmac(payload));
    }

    /** Returns the user from a valid cookie; null when missing, tampered with or expired. */
    private Authentication read(String value) {
        if (value == null) {
            return null;
        }
        try {
            int dot = value.indexOf('.');
            if (dot < 0) {
                return null;
            }
            String payload = value.substring(0, dot);
            byte[] signature = DECODER.decode(value.substring(dot + 1));
            if (!MessageDigest.isEqual(signature, hmac(payload))) {
                return null;
            }
            String[] parts = new String(DECODER.decode(payload), StandardCharsets.UTF_8).split("\n", 3);
            if (parts.length != 3 || Instant.now().getEpochSecond() > Long.parseLong(parts[0])) {
                return null;
            }
            List<GrantedAuthority> authorities = AuthorityUtils.commaSeparatedStringToAuthorityList(parts[1]);
            return UsernamePasswordAuthenticationToken.authenticated(parts[2], null, authorities);
        } catch (IllegalArgumentException e) {
            return null; // not valid base64 or not a number: treat as signed out
        }
    }

    private byte[] hmac(String payload) {
        try {
            // A Mac instance is not thread-safe, so create one per call (cheap)
            Mac mac = Mac.getInstance(HMAC);
            mac.init(key);
            return mac.doFinal(payload.getBytes(StandardCharsets.US_ASCII));
        } catch (GeneralSecurityException e) {
            throw new IllegalStateException(e);
        }
    }

    /** {@code maxAge} null = session cookie: the browser drops it when closed; the payload has its own expiry. */
    private static String cookie(String value, Duration maxAge) {
        // Secure is fine on http://localhost too: browsers treat localhost as a secure context
        ResponseCookie.ResponseCookieBuilder cookie = ResponseCookie.from(COOKIE, value)
                .httpOnly(true)
                .secure(true)
                .sameSite("Lax")
                .path("/");
        if (maxAge != null) {
            cookie.maxAge(maxAge);
        }
        return cookie.build().toString();
    }

    private static String cookieValue(HttpServletRequest request) {
        if (request.getCookies() == null) {
            return null;
        }
        return Arrays.stream(request.getCookies())
                .filter(cookie -> cookie.getName().equals(COOKIE))
                .map(Cookie::getValue)
                .filter(value -> !value.isEmpty())
                .findFirst()
                .orElse(null);
    }
}
