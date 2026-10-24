package com.jarloom.visitor;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Registers the page-view logging for all pages, so a new page is logged without extra code in its controller.
 */
@Configuration
public class VisitorWebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new VisitorTrackingInterceptor());
    }
}
