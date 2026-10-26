package com.beanwind.page;

import java.util.Arrays;
import java.util.stream.Collectors;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Files for crawlers at the site root: robots.txt (rules for all crawlers, AI crawlers included), sitemap.xml
 * (the pages to index) and llms.txt (a Markdown summary for AI tools, see https://llmstxt.org).
 * Generated rather than static files, because they need absolute URLs ({@code site.base-url}).
 * See the README section "Search engines and AI crawlers".
 */
@RestController
public class CrawlerController {

    private static final String SOURCE_CODE = "https://github.com/hi-rullah/beanwind-site";

    private final SiteProperties site;

    public CrawlerController(SiteProperties site) {
        this.site = site;
    }

    @GetMapping(value = "/robots.txt", produces = MediaType.TEXT_PLAIN_VALUE)
    public String robots() {
        return """
                # Every crawler is welcome: search engines and AI crawlers (GPTBot, ClaudeBot, PerplexityBot, ...).
                # Sign-in and member pages are not blocked here: they carry <meta name="robots" content="noindex">,
                # which a crawler only sees when it may fetch the page.
                User-agent: *
                Allow: /

                Sitemap: %s
                """.formatted(site.url("/sitemap.xml"));
    }

    @GetMapping(value = "/sitemap.xml", produces = MediaType.APPLICATION_XML_VALUE)
    public String sitemap() {
        String urls = Arrays.stream(PublicPage.values())
                .map(page -> "  <url><loc>" + site.url(page.path()) + "</loc></url>\n")
                .collect(Collectors.joining());
        return """
                <?xml version="1.0" encoding="UTF-8"?>
                <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
                %s</urlset>
                """.formatted(urls);
    }

    @GetMapping(value = "/llms.txt", produces = MediaType.TEXT_PLAIN_VALUE)
    public String llms() {
        String pages = Arrays.stream(PublicPage.values())
                .map(page -> "- [" + page.title() + "](" + site.url(page.path()) + "): " + page.description() + "\n")
                .collect(Collectors.joining());
        return """
                # Beanwind

                > A server-rendered Java web app built with Spring Boot 4, JTE templates and Tailwind CSS v4, \
                with Spring Security login. No React, no Node.js, no npm: the whole UI ships in one JAR.

                ## Pages

                %s
                ## Source code

                - [GitHub repository](%s): setup, architecture, Spring Security and deployment notes in the README
                """.formatted(pages, SOURCE_CODE);
    }
}
