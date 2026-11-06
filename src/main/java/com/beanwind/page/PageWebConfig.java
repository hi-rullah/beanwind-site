package com.beanwind.page;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Registers {@link SharedCacheInterceptor}, which makes the pages marked with {@link SharedCache} cacheable.
 */
@Configuration
public class PageWebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new SharedCacheInterceptor());
    }
}
