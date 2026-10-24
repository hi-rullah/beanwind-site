package com.beanwind.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.event.EventListener;
import org.springframework.security.authentication.event.AbstractAuthenticationFailureEvent;
import org.springframework.security.authentication.event.AuthenticationSuccessEvent;
import org.springframework.security.authentication.event.LogoutSuccessEvent;
import org.springframework.stereotype.Component;

/**
 * Logs sign-in, failed sign-in and sign-out events published by Spring Security.
 * Passwords are never logged.
 */
@Component
public class AuthenticationEventLogger {

    private static final Logger log = LoggerFactory.getLogger(AuthenticationEventLogger.class);

    @EventListener
    public void onSuccess(AuthenticationSuccessEvent event) {
        log.info("login_success user={}", clean(event.getAuthentication().getName()));
    }

    @EventListener
    public void onFailure(AbstractAuthenticationFailureEvent event) {
        log.warn("login_failure user={} reason={}",
                clean(event.getAuthentication().getName()),
                event.getException().getClass().getSimpleName());
    }

    @EventListener
    public void onLogout(LogoutSuccessEvent event) {
        log.info("logout user={}", clean(event.getAuthentication().getName()));
    }

    /** The username of a failed sign-in is whatever was typed: drop control characters so it cannot fake log lines. */
    private static String clean(String value) {
        if (value == null || value.isBlank()) {
            return "-";
        }
        String cleaned = value.replaceAll("[\\p{Cntrl}\"]", "");
        return cleaned.length() > 100 ? cleaned.substring(0, 100) : cleaned;
    }
}
