package com.beanwind.page;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

/**
 * Adds {@code site} to every page's model, for absolute links in templates: {@code site.url("/about")}.
 * Like {@code currentUser}, a page declares it as a param to use it.
 */
@ControllerAdvice
@EnableConfigurationProperties(SiteProperties.class)
public class SiteAdvice {

    private final SiteProperties site;

    public SiteAdvice(SiteProperties site) {
        this.site = site;
    }

    @ModelAttribute("site")
    public SiteProperties site() {
        return site;
    }
}
