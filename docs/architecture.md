# Architecture — the frontend tier

javaview-site is the **presentation tier** of a classic three-tier application.
It renders HTML on the server with Spring Boot + JTE + Tailwind and gets all of its data from a separate backend service.

```
┌──────────┐  HTML   ┌──────────────────────────────┐  REST/JSON  ┌──────────────────┐  SQL  ┌──────────┐
│ Browser  │ ◀─────▶ │ javaview-site  (THIS REPO)   │ ──────────▶ │ Backend service  │ ────▶ │ Database │
└──────────┘         │ presentation tier            │             │ (separate repo)  │       └──────────┘
                     │ • pages: JTE templates       │             │ • business logic │
                     │ • styling: Tailwind CSS      │             │ • REST API       │
                     │ • login/session: Spring Sec. │             │ • persistence    │
                     │ • backend client: RestClient │             └──────────────────┘
                     └──────────────────────────────┘
```

## What belongs where

| In this repo (frontend tier) | In the backend repo |
|---|---|
| Controllers that pick a template and fill its model | Business rules and validation that must never be bypassed |
| JTE templates, CSS, JS, images | REST API |
| User login, session, CSRF protection | Authorization of every API call |
| Calling the backend (`RestClient`) | Database access (JPA/JDBC), migrations |
| Form input checks for nicer UX | Final validation of data |

Rules of thumb:
- **No database dependency here** (no JPA, JDBC or DB drivers). If a page needs data, it asks the backend.
- **No business logic here.** Controllers stay thin: call the backend, put the result in the model, return a template.
- **Never trust the frontend alone for security.** Spring Security here protects pages; the backend must still check every request.

---

## Connecting to the backend

### Configuration

`src/main/resources/application.yml`:
```yaml
backend:
  base-url: ${BACKEND_BASE_URL:http://localhost:8081}
```

| Setting | Local development | Server (e.g. AWS Lambda) |
|---|---|---|
| `backend.base-url` | default `http://localhost:8081` | env var `BACKEND_BASE_URL` |
| `backend.api-key` | `secret.yml` | env var `BACKEND_API_KEY` |

Spring Boot maps environment variables to properties automatically (`BACKEND_API_KEY` → `backend.api-key`).

### Code

- `config/BackendProperties.java` — record bound to `backend.*`
- `config/BackendClientConfig.java` — a ready-made `RestClient` bean with the base URL and API-key header

Using it in a controller:
```java
@Controller
public class ProductController {

    private final RestClient backend;

    public ProductController(RestClient backendRestClient) {
        this.backend = backendRestClient;
    }

    @GetMapping("/products")
    public String products(Model model) {
        Product[] products = backend.get().uri("/api/products").retrieve().body(Product[].class);
        model.addAttribute("products", products);
        return "products";
    }
}
```

The client is created with `RestClient.builder()` from Spring Web, which is already on the classpath, so no extra dependency is needed.
To get Spring Boot's auto-configured `RestClient.Builder` instead (shared message converters, observability), add
`spring-boot-starter-restclient` — in Spring Boot 4 it is no longer part of the web starter.

---

## Secrets: `secret.yml`

Like a `.env` file in a JavaScript frontend:

| File | In git? | Purpose |
|---|---|---|
| `secret.example.yml` | yes | Lists the secret keys with fake values |
| `secret.yml` | **no** (gitignored) | Your real local values |

```
copy secret.example.yml secret.yml
```

`application.yml` loads it with `spring.config.import: optional:file:./secret.yml`:
- `optional:` — the app starts normally when the file doesn't exist
- `file:./` — read from the working directory (project root with `mvnw spring-boot:run`), **not** from the classpath,
  so the file is never packaged into the jar or uploaded with a deployment
- values in `secret.yml` override `application.yml` and `application-prod.yml`/`application-dev.yml`
- any property can go there, not only secrets

On a server there is no `secret.yml`; set environment variables instead (for Lambda: `Environment.Variables` in
`deploy/aws-lambda/template.yaml`, or AWS Secrets Manager / SSM Parameter Store for real secrets).

---

## Spring Security (guide — not enabled in this project)

The landing page has no login, so Spring Security is **not** added. A real frontend tier with user accounts would add it here.
The snippets below are a starting point for Spring Boot 4.1 / Spring Security 7 and are **not compiled in this repo** —
check them against the [Spring Security reference](https://docs.spring.io/spring-security/reference/) when you use them.

### 1. Dependencies

```xml
<!-- login, sessions, CSRF protection -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>

<!-- optional: "Log in with Google / Keycloak / Cognito" (OAuth2 / OpenID Connect) -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security-oauth2-client</artifactId>
</dependency>
```
In Spring Boot 4 the OAuth2 login starter is `spring-boot-starter-security-oauth2-client`;
the old name `spring-boot-starter-oauth2-client` still exists but is deprecated.

As soon as `spring-boot-starter-security` is on the classpath, **every page requires login** with a generated password.
Add a `SecurityFilterChain` to choose what stays public.

### 2. Which pages are public

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/", "/about", "/error").permitAll()
                .requestMatchers("/css/**", "/js/**", "/images/**").permitAll()
                .anyRequest().authenticated())
            .formLogin(Customizer.withDefaults())      // or .oauth2Login(Customizer.withDefaults())
            .logout(Customizer.withDefaults());
        return http.build();
    }
}
```

### 3. Login options for a frontend tier

| Option | When | Notes |
|---|---|---|
| Form login (`formLogin`) | Users/passwords managed by your own backend | Implement a `UserDetailsService` that asks the backend to verify the user |
| OAuth2 / OpenID Connect (`oauth2Login`) | Login via Google, Keycloak, AWS Cognito, … | Provider settings go in `spring.security.oauth2.client.*`; the client secret goes in `secret.yml` / env vars |

### 4. Things to keep in mind

- **CSRF:** keep it enabled. Every form that POSTs must send the CSRF token as a hidden field.
  JTE templates only see their declared `@param`s, so pass the token in explicitly — e.g. a `@ControllerAdvice` that adds
  the `CsrfToken` (request attribute `_csrf`) to the model, then in the template:
  `<input type="hidden" name="${csrf.getParameterName()}" value="${csrf.getToken()}">`.
- **Calling the backend as the user:** with OAuth2 login, forward the user's access token to the backend
  (`Authorization: Bearer …`) so the backend can authorize each call; the static `X-API-Key` only identifies this frontend app.
- **Sessions on AWS Lambda:** the default HTTP session lives in memory, and Lambda runs many short-lived instances,
  so a user could be "logged out" when a request hits another instance. Use an external session store
  (Spring Session with Redis/DynamoDB/JDBC) or a deployment with long-lived instances before adding login.
- **Dev tools:** keep dev-only settings in `application-dev.yml`; never disable security in `prod`.
