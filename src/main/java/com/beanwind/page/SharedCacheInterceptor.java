package com.beanwind.page;

import java.time.Duration;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

/**
 * Lets a CDN (e.g. CloudFront) and browsers cache the pages marked with {@link SharedCache}, but only the copy a
 * signed-out visitor gets. Every other response keeps Spring Security's default {@code no-store}.
 *
 * <p>A page is cacheable only if all of these hold:
 * <ul>
 *   <li>GET or HEAD, status 200</li>
 *   <li>nobody is signed in: the navbar shows the user's name otherwise</li>
 *   <li>the response sets no cookie (e.g. the {@code bw_visitor} analytics cookie): a cache would hand that
 *       cookie to every visitor</li>
 * </ul>
 * The CDN must still keep signed-in visitors apart: its cache key has to include the {@code bw_auth} cookie,
 * so a request with that cookie never gets the anonymous copy.
 *
 * <p>Spring Security only adds its {@code no-store} headers when the response has no {@code Cache-Control} yet,
 * so the header set here is kept.
 */
public class SharedCacheInterceptor implements HandlerInterceptor {

    /** Browsers: 1 minute. CDN: 10 minutes; each deploy clears the CDN cache. */
    static final String CACHE_CONTROL = CacheControl.maxAge(Duration.ofMinutes(1))
            .cachePublic()
            .sMaxAge(Duration.ofMinutes(10))
            .getHeaderValue();

    /** The same headers Spring Security writes by default. */
    private static final String NO_STORE = "no-cache, no-store, max-age=0, must-revalidate";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        // If rendering a cacheable page failed after postHandle, its header is still set: the error page must not be cached
        if (request.getDispatcherType() == DispatcherType.ERROR && response.containsHeader(HttpHeaders.CACHE_CONTROL)) {
            response.setHeader(HttpHeaders.CACHE_CONTROL, NO_STORE);
        }
        return true;
    }

    /** Runs after the handler and after every interceptor's preHandle (which may set cookies), before the view renders. */
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) {
        if (handler instanceof HandlerMethod method
                && method.hasMethodAnnotation(SharedCache.class)
                && request.getDispatcherType() == DispatcherType.REQUEST
                && ("GET".equals(request.getMethod()) || "HEAD".equals(request.getMethod()))
                && response.getStatus() == HttpStatus.OK.value()
                && request.getUserPrincipal() == null
                && !response.containsHeader(HttpHeaders.SET_COOKIE)) {
            response.setHeader(HttpHeaders.CACHE_CONTROL, CACHE_CONTROL);
        }
    }
}
