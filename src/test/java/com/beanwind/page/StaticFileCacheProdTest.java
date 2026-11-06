package com.beanwind.page;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.resttestclient.autoconfigure.AutoConfigureRestTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpHeaders;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.client.RestTestClient;

/** The prod profile's Cache-Control for static files (application-prod.yml). */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
        properties = "auth.cookie-secret=test-secret-test-secret-test-secret-1234")
@ActiveProfiles("prod")
@AutoConfigureRestTestClient
class StaticFileCacheProdTest {

    @Autowired
    RestTestClient client;

    @Test
    void staticFilesAreCachedOneHourByBrowsersAndOneYearByTheCdn() {
        client.get().uri("/css/output.css").exchange()
                .expectStatus().isOk()
                .expectHeader().valueEquals(HttpHeaders.CACHE_CONTROL, "max-age=3600, public, s-maxage=31536000");
    }
}
