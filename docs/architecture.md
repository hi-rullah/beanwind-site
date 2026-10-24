# Architecture — the frontend tier

beanwind-site is the **presentation tier** of a classic three-tier application.
It renders HTML on the server with Spring Boot + JTE + Tailwind and gets all of its data from a separate backend service.

```
┌──────────┐  HTML   ┌──────────────────────────────┐  REST/JSON  ┌──────────────────┐  SQL  ┌──────────┐
│ Browser  │ ◀─────▶ │ beanwind-site  (THIS REPO)   │ ──────────▶ │ Backend service  │ ────▶ │ Database │
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

## Spring Security

Spring Security is part of this project. For the demo it uses **form login with one in-memory user** (`demo` / `demo`);
`/secured` is the page that requires login. Code: `config/SecurityConfig.java`, pages `login.jte` and `secured.jte`.

### Do not build your own user management

The in-memory demo user exists only to show how Spring Security protects a page. Storing users and passwords yourself
means you also own password hashing, resets, account lockout, leaked-password checks, two-factor login and the
protection of personal data — hard to get right and not recommended. Real applications should delegate sign-in to a
proven identity provider through **OAuth2 / OpenID Connect** (GitHub, Google, Keycloak, AWS Cognito, Auth0, Okta,
Entra ID, ...). Spring Security supports this with `oauth2Login()`; the app then never sees a password.

### 1. What is configured

| Rule | Paths |
|---|---|
| Public | `/`, `/about`, `/login`, `/error`, `/css/**`, `/js/**`, `/fonts/**`, `/images/**` |
| Login required | everything else, e.g. `/secured` (new pages are protected by default) |

- Login form: `GET /login` is our JTE page, `POST /login` is handled by Spring Security; success goes to `/secured`.
- Logout: `POST /logout` (with CSRF token) deletes the `bw_auth` cookie and redirects to `/`.
- No HTTP session (`STATELESS`): the signed-in user is kept in the `bw_auth` cookie, signed with HMAC-SHA256
  (`security/SignedCookieSecurityContextRepository`), and the CSRF token in the `bw_csrf` cookie. Any instance can
  check both, so the app runs on any number of instances (see below). The signing key is `auth.cookie-secret`: required in prod
  (`AUTH_COOKIE_SECRET`), random per start locally when not set.
- Errors render `error.jte` (`server.error.whitelabel.enabled: false` in `application.yml`).
- Passwords: `BCryptPasswordEncoder`; the demo password is hashed at startup.
- Templates get the logged-in user through `security/CurrentUserAdvice` (model attribute `currentUser`),
  which every page passes to `layout/navbar.jte`.
- `application-prod.yml` sets `Cache-Control: max-age=3600` on static files; otherwise Spring Security marks them `no-store`.

### 2. GitHub and Google login (prepared, commented out)

Everything is in place but commented out, so it can be enabled in a later version:

1. `pom.xml` — uncomment `spring-boot-starter-security-oauth2-client`
   (Boot 4 name; the old `spring-boot-starter-oauth2-client` still exists but is deprecated).
2. `application.yml` — uncomment `spring.security.oauth2.client.registration` (github, google).
3. Register an OAuth app with each provider. Callback URL: `{base-url}/login/oauth2/code/github` (or `.../google`).
   A GitHub OAuth App allows one callback URL, so register one for `http://localhost:8080` and one for the deployed URL.
4. Put the client IDs and secrets in `secret.yml` locally (see `secret.example.yml`) or in environment variables on a
   server — never in committed files.
5. `SecurityConfig` — uncomment `.oauth2Login(...)`; `login.jte` — uncomment the "Continue with GitHub / Google" buttons.

For GitHub the principal name is the numeric user ID; read the `login` attribute of the `OAuth2User` to show the username.
Behind a proxy such as the Lambda Function URL, Spring must know the original `https` URL to build the callback URL;
check `server.forward-headers-strategy` when testing on the deployed site.

### 3. Login options for a frontend tier

| Option | When | Notes |
|---|---|---|
| OAuth2 / OpenID Connect (`oauth2Login`) | **Recommended.** Login via GitHub, Google, Keycloak, AWS Cognito, … | Provider settings in `spring.security.oauth2.client.*`; client secret in `secret.yml` / env vars |
| Form login (`formLogin`) | Demos, or users managed by your own backend | Here: in-memory demo user. Otherwise a `UserDetailsService` that asks the backend to verify the user |

### 4. Things to keep in mind

- **CSRF:** keep it enabled. Every form that POSTs must send the CSRF token as a hidden field.
  JTE templates only see their declared `@param`s, so the controller adds the `CsrfToken` to the model
  (see `PageController` for `/login` and `/secured`), then in the template:
  `<input type="hidden" name="${csrf.getParameterName()}" value="${csrf.getToken()}">`.
- **Calling the backend as the user:** with OAuth2 login, forward the user's access token to the backend
  (`Authorization: Bearer …`) so the backend can authorize each call; the static `X-API-Key` only identifies this frontend app.
- **Why no HTTP session:** the default session lives in one instance's memory. As soon as more than one instance
  serves the app (load balancer, autoscaling, serverless), a request can reach an instance that does not know the
  session: the CSRF token is missing (403 on `POST /login`) and sign-ins are randomly lost. Cookies travel with every
  request, so they work on any instance. The cookie only holds the username and authorities; if more per-user state is ever needed, use an external
  session store (Spring Session with Redis/JDBC) instead.
- **Dev tools:** keep dev-only settings in `application-dev.yml`; never disable security in `prod`.

---

## Visitor logging and cookies

Every page view writes one log line (static files are not logged), via `visitor/VisitorTrackingInterceptor`:

```
page_view method=GET path=/about status=200 visitor=- user=- ip=203.0.113.0 referer="https://example.com/" ua="Mozilla/5.0 ..."
```

- **No cookie needed** for this: page, status, referrer and browser come with every request.
- **IP addresses are anonymized** before logging (IPv4 /24, IPv6 /48). Behind the Lambda Function URL the client
  address is the first `X-Forwarded-For` entry.
- **Visitor ID cookie only with consent.** The cookie banner (`layout/cookieBanner.jte` + `js/layout/consent.js`)
  stores the choice in `bw_consent`. Only after `accepted` does the server set `bw_visitor` (random UUID, HttpOnly,
  6 months) to count returning visitors; after `rejected` it deletes it. Reject is as easy as accept, and
  "Cookie settings" in the footer reopens the banner. Without JavaScript nothing is accepted.
- Client-supplied values (user agent, referrer, usernames) are stripped of quotes and control characters so they
  cannot forge log lines.
- Sign-in events are logged by `security/AuthenticationEventLogger`: `login_success`, `login_failure`, `logout`.
- The `/privacy` page explains all of this to visitors. **Keep it in sync with the code**, including the log retention
  it promises (30 days): set the Lambda log group retention accordingly.

**Where the logs go**

| Profile | Output | Retention |
|---|---|---|
| `dev` | console + `log/app.log` (application, security events) + `log/visitor.log` (page views only) | daily files, 30 days (`application-dev.yml`) |
| `prod` (AWS Lambda) | console only; Lambda sends it to CloudWatch Logs | set on the log group (30 days) |

Page views get their own file because they contain personal data (visitor ID, anonymized IP, username), so their
retention and deletion can be handled separately from application logs. The setup is in `logback-spring.xml`;
folder and retention are configured in `application-dev.yml` (`logging.file.path`, `logging.logback.rollingpolicy.*`).
On Lambda no files are written: the disk is read-only and temporary, and the platform stores console output.

Do **not** send each page view to the backend over HTTP: it adds a network call to every page and makes pages depend
on the backend. To get visitor data into a database later, ship the `visitor` log lines asynchronously
(e.g. CloudWatch → Firehose → S3, or a queue the backend reads).

On AWS Lambda the lines go to CloudWatch Logs. Example CloudWatch Logs Insights queries:

```
# page views per page
filter @message like /page_view/
| parse @message "path=* " as path
| stats count() as views by path
| sort views desc

# unique visitors (only those who accepted the analytics cookie)
filter @message like /page_view/ and @message not like /visitor=- /
| parse @message "visitor=* " as visitor
| stats count_distinct(visitor) as visitors
```

Rules like GDPR / ePrivacy apply to EU visitors. This setup follows common practice (no tracking cookie without
consent, anonymized IPs, short retention, a clear privacy page), but it is not legal advice.

