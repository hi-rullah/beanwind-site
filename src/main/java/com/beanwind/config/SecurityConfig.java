package com.beanwind.config;

import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;

import com.beanwind.security.SignedCookieSecurityContextRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;

/**
 * Form login with one in-memory demo user (demo / demo). Pages are public unless listed as protected;
 * /secured is the demo page that requires login.
 *
 * <p><b>Demo only — do not build your own user management.</b> Storing users and passwords yourself means
 * also handling password resets, account lockout, breached passwords, MFA and data protection. Real apps
 * should let a proven identity provider do this through OAuth2 / OpenID Connect: GitHub, Google, Keycloak,
 * AWS Cognito, Auth0, Okta, Entra ID, ... Spring Security supports them with {@code oauth2Login()}.
 *
 * <p>GitHub and Google login are prepared below but commented out. To enable them:
 * <ol>
 *   <li>pom.xml: uncomment {@code spring-boot-starter-security-oauth2-client}</li>
 *   <li>application.yml: uncomment {@code spring.security.oauth2.client.registration}</li>
 *   <li>secret.yml: set the client IDs and secrets (see secret.example.yml)</li>
 *   <li>here: uncomment {@code .oauth2Login(...)}</li>
 *   <li>login.jte: uncomment the "Continue with GitHub / Google" buttons</li>
 * </ol>
 * Note: for GitHub the principal name is the numeric user ID; read the {@code login} attribute of the
 * {@code OAuth2User} if the navbar should show the GitHub username instead.
 *
 * <p><b>No HTTP session.</b> The default session lives in one server's memory, so it only works when every request
 * reaches the same server. To run on any number of instances, the signed-in user is kept in a signed cookie
 * ({@link SignedCookieSecurityContextRepository}) and the CSRF token in a cookie too: any instance can handle any request.
 */
@Configuration
public class SecurityConfig {

    private static final Logger log = LoggerFactory.getLogger(SecurityConfig.class);

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   SignedCookieSecurityContextRepository securityContextRepository) throws Exception {
        http
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .securityContext(context -> context.securityContextRepository(securityContextRepository))
                .csrf(csrf -> csrf.csrfTokenRepository(csrfTokenRepository()))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/", "/about", "/privacy", "/login", "/error").permitAll()
                        .requestMatchers("/css/**", "/js/**", "/fonts/**", "/images/**").permitAll()
                        .requestMatchers("/robots.txt", "/sitemap.xml", "/llms.txt").permitAll()
                        .anyRequest().authenticated())
                .formLogin(form -> form
                        .loginPage("/login")
                        .defaultSuccessUrl("/secured")
                        .failureHandler(loginFailureHandler()))
                // OAuth2 login (GitHub, Google): the buttons link to /oauth2/authorization/{github|google},
                // the provider redirects back to /login/oauth2/code/{github|google}
                // .oauth2Login(oauth2 -> oauth2
                //         .loginPage("/login")
                //         .defaultSuccessUrl("/secured"))
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        // the security context repository deletes the bw_auth cookie
                        .logoutSuccessUrl("/"));
        return http.build();
    }

    /**
     * {@code auth.cookie-secret} signs the login cookie. All instances must share it, and changing it signs everyone out.
     * Prod requires it (AUTH_COOKIE_SECRET, see application-prod.yml); locally a random one is used when it is not set.
     */
    @Bean
    public SignedCookieSecurityContextRepository securityContextRepository(@Value("${auth.cookie-secret:}") String secret) {
        if (secret.isBlank()) {
            log.warn("auth.cookie-secret is not set: using a random key, so sign-ins are lost on restart");
            byte[] random = new byte[32];
            new SecureRandom().nextBytes(random);
            return new SignedCookieSecurityContextRepository(random);
        }
        if (secret.length() < 32) {
            throw new IllegalStateException("auth.cookie-secret must be at least 32 characters");
        }
        return new SignedCookieSecurityContextRepository(secret.getBytes(StandardCharsets.UTF_8));
    }

    /** Same as the default (redirect to /login?error), but without storing the exception in a new HTTP session. */
    private static SimpleUrlAuthenticationFailureHandler loginFailureHandler() {
        SimpleUrlAuthenticationFailureHandler handler = new SimpleUrlAuthenticationFailureHandler("/login?error");
        handler.setAllowSessionCreation(false);
        return handler;
    }

    /** CSRF token in an HttpOnly cookie instead of the session; forms still send it as a hidden field. */
    private static CookieCsrfTokenRepository csrfTokenRepository() {
        CookieCsrfTokenRepository repository = new CookieCsrfTokenRepository();
        repository.setCookieName("bw_csrf");
        repository.setCookieCustomizer(cookie -> cookie.sameSite("Lax"));
        return repository;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public UserDetailsService userDetailsService(PasswordEncoder passwordEncoder) {
        // Demo only: the credentials are public and shown on the login page
        return new InMemoryUserDetailsManager(User.withUsername("demo")
                .password(passwordEncoder.encode("demo"))
                .roles("USER")
                .build());
    }
}
