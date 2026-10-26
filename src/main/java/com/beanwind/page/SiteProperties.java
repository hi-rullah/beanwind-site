package com.beanwind.page;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * The site's public address, bound from {@code site.*} in application.yml. Absolute links use it instead of the
 * request's host, so they always name the public address, however a request arrived: canonical links,
 * Open Graph tags, robots.txt, sitemap.xml and llms.txt.
 */
@ConfigurationProperties("site")
public record SiteProperties(
        String baseUrl
) {

    /** Absolute URL of a path, e.g. {@code url("/about")} → {@code https://example.com/about}. */
    public String url(String path) {
        return baseUrl.replaceAll("/+$", "") + path;
    }
}
