package com.javaview.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

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
 */
@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/", "/about", "/privacy", "/login", "/error").permitAll()
                        .requestMatchers("/css/**", "/js/**", "/fonts/**", "/images/**").permitAll()
                        .anyRequest().authenticated())
                .formLogin(form -> form
                        .loginPage("/login")
                        .defaultSuccessUrl("/secured"))
                // OAuth2 login (GitHub, Google): the buttons link to /oauth2/authorization/{github|google},
                // the provider redirects back to /login/oauth2/code/{github|google}
                // .oauth2Login(oauth2 -> oauth2
                //         .loginPage("/login")
                //         .defaultSuccessUrl("/secured"))
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID"));
        return http.build();
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
