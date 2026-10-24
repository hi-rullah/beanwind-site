package com.jarloom.security;

/**
 * The logged-in user as the templates see it; {@code name} is null for anonymous visitors.
 */
public record CurrentUser(
        String name
) {

    public static final CurrentUser ANONYMOUS = new CurrentUser(null);

    public boolean loggedIn() {
        return name != null;
    }
}
