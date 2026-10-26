package com.beanwind.page;

/**
 * The pages search engines and AI tools should find. One list for sitemap.xml, llms.txt and each page's
 * meta description, so they cannot drift apart. Sign-in, member and error pages are not listed: they are noindex.
 */
public enum PublicPage {

    HOME("/", "Home",
            "Build server-rendered Java web apps with Spring Boot 4, JTE templates and Tailwind CSS v4: one JAR, no React, no Node.js, no npm."),
    ABOUT("/about", "About",
            "Why Beanwind exists and how it works: pages rendered on the server with JTE, styled with Tailwind CSS v4, protected by Spring Security."),
    PRIVACY("/privacy", "Privacy & cookies",
            "What Beanwind logs on each page view, which cookies it uses and how you can choose.");

    private final String path;
    private final String title;
    private final String description;

    PublicPage(String path, String title, String description) {
        this.path = path;
        this.title = title;
        this.description = description;
    }

    public String path() {
        return path;
    }

    public String title() {
        return title;
    }

    public String description() {
        return description;
    }
}
