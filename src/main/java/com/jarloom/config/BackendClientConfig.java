package com.jarloom.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

/**
 * HTTP client for the backend service. Controllers inject {@link RestClient} to fetch data, e.g.
 * {@code backendRestClient.get().uri("/api/products").retrieve().body(Product[].class)}.
 * Creating the client opens no connection, so it is safe even when no backend is running.
 */
@Configuration
@EnableConfigurationProperties(BackendProperties.class)
public class BackendClientConfig {

    @Bean
    public RestClient backendRestClient(BackendProperties backend) {

        RestClient.Builder builder = RestClient.builder().baseUrl(backend.baseUrl());

        if (backend.apiKey() != null && !backend.apiKey().isBlank()) {
            // Header name is an example; use whatever the backend expects
            builder.defaultHeader("X-API-Key", backend.apiKey());
        }
        return builder.build();
    }
}
