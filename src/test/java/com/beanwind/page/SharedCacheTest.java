package com.beanwind.page;

import java.util.List;

import com.beanwind.security.SignedCookieSecurityContextRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.resttestclient.autoconfigure.AutoConfigureRestTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpHeaders;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextImpl;
import org.springframework.test.web.servlet.client.RestTestClient;

/**
 * Which responses a CDN may cache (see {@link SharedCacheInterceptor}). Real server, real Spring Security filters:
 * the point is that Spring Security keeps the Cache-Control header the interceptor sets.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureRestTestClient
class SharedCacheTest {

    private static final String NO_STORE = "no-cache, no-store, max-age=0, must-revalidate";

    @Autowired
    RestTestClient client;

    @Autowired
    SignedCookieSecurityContextRepository securityContextRepository;

    @Test
    void anonymousHomeAndAboutAreCacheable() {
        for (String path : List.of("/", "/about")) {
            client.get().uri(path).exchange()
                    .expectStatus().isOk()
                    .expectHeader().valueEquals(HttpHeaders.CACHE_CONTROL, "max-age=60, public, s-maxage=600")
                    .expectHeader().doesNotExist(HttpHeaders.SET_COOKIE)
                    .expectHeader().doesNotExist(HttpHeaders.PRAGMA);
        }
    }

    @Test
    void signedInVisitorIsNotCached() {
        client.get().uri("/").cookie(SignedCookieSecurityContextRepository.COOKIE, signedInCookie()).exchange()
                .expectStatus().isOk()
                .expectHeader().valueEquals(HttpHeaders.CACHE_CONTROL, NO_STORE)
                .expectBody(String.class).value(html -> {
                    if (!html.contains("Signed in as demo")) {
                        throw new AssertionError("expected the signed-in navbar");
                    }
                });
    }

    @Test
    void responseThatSetsTheVisitorCookieIsNotCached() {
        // Analytics accepted but no visitor ID yet: the response sets bw_visitor
        client.get().uri("/").cookie("bw_consent", "accepted").exchange()
                .expectStatus().isOk()
                .expectHeader().exists(HttpHeaders.SET_COOKIE)
                .expectHeader().valueEquals(HttpHeaders.CACHE_CONTROL, NO_STORE);
    }

    @Test
    void responseThatDeletesTheVisitorCookieIsNotCached() {
        client.get().uri("/about").cookie("bw_consent", "rejected").cookie("bw_visitor", "old").exchange()
                .expectStatus().isOk()
                .expectHeader().exists(HttpHeaders.SET_COOKIE)
                .expectHeader().valueEquals(HttpHeaders.CACHE_CONTROL, NO_STORE);
    }

    @Test
    void unmarkedPagesAndErrorsAreNotCached() {
        client.get().uri("/privacy").exchange()
                .expectStatus().isOk()
                .expectHeader().valueEquals(HttpHeaders.CACHE_CONTROL, NO_STORE);
        client.get().uri("/login").exchange()
                .expectStatus().isOk()
                .expectHeader().valueEquals(HttpHeaders.CACHE_CONTROL, NO_STORE);
        client.get().uri("/no-such-page").exchange()
                .expectStatus().isNotFound()
                .expectHeader().valueEquals(HttpHeaders.CACHE_CONTROL, NO_STORE);
    }

    /** A valid bw_auth cookie for "demo", made the same way a real sign-in makes it. */
    private String signedInCookie() {
        var authentication = UsernamePasswordAuthenticationToken.authenticated(
                "demo", null, AuthorityUtils.createAuthorityList("ROLE_USER"));
        var response = new MockHttpServletResponse();
        securityContextRepository.saveContext(new SecurityContextImpl(authentication), new MockHttpServletRequest(), response);
        String setCookie = response.getHeader(HttpHeaders.SET_COOKIE);
        return setCookie.substring(setCookie.indexOf('=') + 1, setCookie.indexOf(';'));
    }
}
