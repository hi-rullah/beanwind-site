package com.beanwind.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Connection settings for the backend service, bound from {@code backend.*} in application.yml.
 * The api key comes from secret.yml locally or the BACKEND_API_KEY environment variable on a server.
 */
@ConfigurationProperties("backend")
public record BackendProperties(
        String baseUrl,
        String apiKey
) {
}
