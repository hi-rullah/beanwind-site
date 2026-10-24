package com.jarloom.security;

import java.security.Principal;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

/**
 * Adds {@code currentUser} to every page's model. JTE templates only see their declared params,
 * so each page declares it and passes it on to layout/navbar.jte.
 */
@ControllerAdvice
public class CurrentUserAdvice {

    @ModelAttribute("currentUser")
    public CurrentUser currentUser(Principal principal) {
        return principal == null ? CurrentUser.ANONYMOUS : new CurrentUser(principal.getName());
    }
}
