# Beanwind Site

A server-rendered Java web app built with **Spring Boot 4 + JTE + Tailwind CSS v4**, with Spring Security login.
No React. No Node.js. No npm. Pure Java.

**Live demo:** https://beanwind.zeybekyilmazltd.com/
(sign in to the secured page with `demo` / `demo`)

---

## Architecture

This repo is the **frontend (presentation) tier** of a three-tier application — it contains no backend business logic and no database access.

```
Browser ──▶ beanwind-site (THIS REPO)  ──REST──▶  Backend service  ──▶  Database
            Spring Boot · JTE · Tailwind           (separate repo)       (backend only)
```

- Pages are rendered here with JTE; data comes from the backend over HTTP (`backend.base-url` in `application.yml`).
- Local secrets go in `secret.yml` (gitignored) — copy `secret.example.yml` to start.
- Spring Security protects `/secured` with a public demo account (`demo` / `demo`). GitHub and Google login (OAuth2) are prepared but commented out — real apps should use OAuth2 instead of storing users themselves.

Details: [`docs/architecture.md`](docs/architecture.md) — tiers, backend connection, secrets, Spring Security.

---

## Prerequisites

- Java 25
- Maven — not required, use the included wrapper (`mvnw` / `mvnw.cmd`)

---

## Step 1 — Download Tailwind CLI for Windows

Tailwind is used as a **standalone binary** — no Node.js or npm needed.

Download the latest Windows binary from:
```
https://github.com/tailwindlabs/tailwindcss/releases/latest
```

File to download: `tailwindcss-windows-x64.exe`

Place it in the **root of this project** (same folder as `pom.xml`).

---

## Step 2 — Build the CSS

Run in terminal or double-click:
```
tailwind-build.bat
```

A successful build prints:
```
✓ tailwindcss v4.2.1
Done in 73ms
Done! output.css generated.
```

This generates: `src/main/resources/static/css/output.css`

---

## Step 3 — Run the App

```
mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

Open browser: http://localhost:8080

---

## Pages

| URL | Page |
|---|---|
| http://localhost:8080/ | Home / Landing page |
| http://localhost:8080/about | About page |
| http://localhost:8080/privacy | Privacy & cookies |
| http://localhost:8080/secured | Requires sign-in (`demo` / `demo`) |
| http://localhost:8080/robots.txt, /sitemap.xml, /llms.txt | For crawlers, see [Search engines and AI crawlers](#search-engines-and-ai-crawlers) |

---

## Development Workflow

Open two terminals side by side:

**Terminal 1** — watch for CSS changes:
```
tailwind-watch.bat
```

**Terminal 2** — run the app:
```
mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

- JTE templates reload instantly on browser refresh (no restart needed)
- CSS rebuilds automatically when `.jte` files change
- New Java controllers require app restart (~2 sec with DevTools)

---

## Project Structure

```
beanwind-site/
├── src/main/java/com/beanwind/
│   ├── Application.java                  ← Spring Boot entry point
│   ├── config/
│   │   ├── BackendProperties.java        ← backend.* settings
│   │   ├── BackendClientConfig.java      ← RestClient for the backend service
│   │   └── SecurityConfig.java           ← Spring Security: public pages, demo user, (commented) OAuth2
│   ├── page/
│   │   ├── PageController.java           ← page route mappings
│   │   ├── PublicPage.java               ← public pages: sitemap, llms.txt, meta descriptions
│   │   ├── CrawlerController.java        ← robots.txt, sitemap.xml, llms.txt
│   │   ├── SiteProperties.java           ← site.base-url: the public address for absolute links
│   │   ├── SiteAdvice.java               ← adds site to every page's model
│   │   └── Assets.java                   ← versioned URLs for css/js
│   ├── security/
│   │   ├── AuthenticationEventLogger.java ← logs sign-in, failed sign-in, sign-out
│   │   ├── CurrentUser.java              ← logged-in user as the templates see it
│   │   └── CurrentUserAdvice.java        ← adds currentUser to every page's model
│   └── visitor/
│       ├── VisitorTrackingInterceptor.java ← one log line per page view; visitor cookie only with consent
│       └── VisitorWebConfig.java         ← registers the interceptor for all pages
├── src/main/jte/
│   ├── layout/
│   │   ├── page.jte                      ← shared page layout: <head>, navbar, content, footer
│   │   ├── navbar.jte                    ← shared navbar (included by page.jte)
│   │   ├── footer.jte                    ← shared footer, year from Year.now() (included by page.jte)
│   │   └── cookieBanner.jte              ← cookie consent banner (included by page.jte)
│   ├── index.jte                         ← Home page
│   ├── about.jte                         ← About page
│   ├── privacy.jte                       ← Privacy & cookies page
│   ├── login.jte                         ← Sign-in page (demo / demo)
│   └── secured.jte                       ← Page that requires login
├── src/main/resources/
│   ├── static/
│   │   ├── css/output.css                ← compiled Tailwind (generated)
│   │   ├── js/                           ← one script per page (index.js, about.js, ...); layout/ for layout scripts (consent.js)
│   │   ├── fonts/                        ← self-hosted Syne + DM Sans (.woff2)
│   │   └── images/                       ← images; favicon/ holds favicons + site.webmanifest, og/ the link-preview image
│   ├── application.yml                   ← app config (+ application-dev/prod.yml)
│   └── logback-spring.xml                ← dev: log/app.log + log/visitor.log (30 days); prod: console
├── docs/architecture.md                  ← three-tier design, backend, secrets, security guide
├── docs/og-image/og-card.html            ← source of the link-preview image
├── deploy/                               ← deployment notes & config per platform
├── secret.example.yml                    ← template for secret.yml (gitignored local secrets)
├── mvnw / mvnw.cmd                       ← Maven wrapper
├── input.css                             ← Tailwind v4 entry point
├── tailwind-build.bat                    ← build CSS once (Windows)
├── tailwind-watch.bat                    ← watch CSS changes (Windows)
├── tailwindcss-windows-x64.exe           ← Tailwind CLI (download in Step 1, gitignored)
└── pom.xml
```

### Static files convention

Everything in `src/main/resources/static/` is served from the site root (`static/js/about.js` → `/js/about.js`).

- **`js/`** — one file per page, named after its template: `index.jte` → `js/index.js`, `about.jte` → `js/about.js`.
  Each page loads only its own script in `<head>`: `<script src="/js/about.js" defer></script>`.
  A new page `contact.jte` gets `js/contact.js`. Scripts used by the layout templates (on every page) live in `js/layout/`,
  e.g. `js/layout/consent.js` for the cookie banner.
- **`fonts/`** — self-hosted fonts (`.woff2`): Syne and DM Sans, Latin subset. Declared with `@font-face` in `input.css`, so they are part of `output.css`; no requests go to Google Fonts.
- **`images/`** — images used by the pages; favicons stay in `images/favicon/`.

---

## Tailwind v4 Notes

This project uses **Tailwind CSS v4**. The config approach changed significantly from v3.

### What is different from v3

**No `tailwind.config.js`** — v4 does not use a config file. It is no longer needed and can be deleted.

**New `input.css` syntax** — v4 uses a single import. The `@source` directive tells Tailwind where to scan for classes:
```css
/* v4 — correct */
@import "tailwindcss";
@source "../src/main/jte";
```

The old v3 syntax no longer works:
```css
/* v3 — do not use */
@tailwind base;
@tailwind components;
@tailwind utilities;
```

**Standalone binary** — always download the latest binary from the releases page. The binary version must be v4+ to match the syntax above.

---

## Favicons

All icons live in `src/main/resources/static/images/favicon/` and are linked from the `<head>` of each page:

| File | Used by |
|---|---|
| `favicon.svg`, `favicon-96x96.png`, `favicon.ico` | Browser tab icon |
| `apple-touch-icon.png` | iOS home screen |
| `site.webmanifest` + `web-app-manifest-192x192.png` / `-512x512.png` | Android home screen / installable web app |

Icons inside `site.webmanifest` use absolute paths (`/images/favicon/...`) — keep them in sync if the folder moves.
Because every page declares its icons, there is no `/favicon.ico` at the site root (requesting it returns 404).

To regenerate the whole set from a new logo, use a generator such as https://realfavicongenerator.net (it produces the same file names).

---

## Search engines and AI crawlers

Server-rendered pages are already easy for crawlers to read: the content is in the HTML, no JavaScript has to run.
On top of that, a public site needs a few files and tags so search engines and AI tools find the right pages
at the right address. This applies to any website, not only this one.

### For search engines

| Item | What it does | In this project |
|---|---|---|
| **`robots.txt`** | Rules for crawlers: what they may fetch, and where the sitemap is. Polite crawlers read it first. | `/robots.txt`: every crawler is allowed, points to the sitemap |
| **`sitemap.xml`** | The list of pages you want indexed | `/sitemap.xml`: the pages in `PublicPage` |
| **Canonical link** | `<link rel="canonical" href="...">` names the one address to index when a page is reachable at several (e.g. a custom domain and the hosting provider's URL) | Public pages, built from `site.base-url` |
| **Meta description** | The text under the title in search results | Public pages, from `PublicPage` |
| **`noindex`** | `<meta name="robots" content="noindex">` keeps a page out of search results | Sign-in, secured and error pages |
| **Open Graph / Twitter cards** | `og:title`, `og:description`, `og:url`, `og:image`: the preview card when a link is shared on LinkedIn, Slack, WhatsApp, X | Public pages, one image for all: see [Link previews](#link-previews-open-graph) |
| **Search Console** | Google Search Console / Bing Webmaster Tools: prove you own the site (DNS TXT record), submit the sitemap, see indexing errors | Not set up yet |
| **Structured data** | JSON-LD `<script type="application/ld+json">` describing the site (organization, article, product, ...) for rich results | Not used; little effect for a small site |

**`noindex` vs. `Disallow`:** to keep a page out of search results, use `noindex`, not `Disallow` in robots.txt.
A crawler that may not fetch a page never sees its `noindex`, and the bare URL can still appear in results when other sites link to it.
That's why this robots.txt allows everything.

### Link previews (Open Graph)

When someone pastes a link into LinkedIn, Slack, WhatsApp, X or Teams, that platform's server fetches the page once
and reads a few `<meta>` tags from its `<head>` to build a preview card: image, title, description, domain.
The tags come from the **Open Graph protocol** (`og:*`, started by Facebook, now used by almost every platform);
X reads its own `twitter:*` tags and falls back to `og:*`.

```html
<meta property="og:title"       content="About — Beanwind">
<meta property="og:description" content="Why Beanwind exists and how it works: ...">
<meta property="og:url"         content="https://beanwind.zeybekyilmazltd.com/about">
<meta property="og:image"       content="https://beanwind.zeybekyilmazltd.com/images/og/beanwind.png">
<meta name="twitter:card"       content="summary_large_image">   <!-- big image instead of a thumbnail -->
```

- **Image:** 1200 × 630 PNG or JPG (not SVG), under about 1 MB, with an absolute URL. This site uses one image for every page:
  `static/images/og/beanwind.png`, made from `docs/og-image/og-card.html` (site fonts, colors and logo; the file says how to render it).
  A page can pass its own with `ogImage = "/images/og/other.png"`.
- **Check a preview** with the platforms' own tools, e.g. LinkedIn Post Inspector (https://www.linkedin.com/post-inspector/),
  or a general one like https://www.opengraph.xyz. Platforms cache a preview for days; their inspector also refreshes it.
- Without these tags a shared link shows as a bare URL, or the platform guesses a title and picks any image from the page.

### For AI crawlers and LLMs

| Item | What it does | In this project |
|---|---|---|
| **robots.txt rules per crawler** | AI crawlers identify themselves and follow robots.txt: `GPTBot` (OpenAI), `ClaudeBot` (Anthropic), `Google-Extended` (Gemini training), `PerplexityBot`, `CCBot` (Common Crawl). Block one with `User-agent: GPTBot` + `Disallow: /`. | All allowed (`User-agent: *`) |
| **`llms.txt`** | A [proposal](https://llmstxt.org) from 2024: a Markdown file at the site root with a short summary and links to the important pages, for AI tools to read. Some documentation sites and AI coding tools use it; search engines don't. | `/llms.txt`: summary, pages, source code link |
| **Markdown versions of pages** | Part of the same proposal: `/about.md` or `Accept: text/markdown` serves a page as Markdown. Useful for documentation sites whose pages get pulled into an AI tool's context. | Not used: the HTML is already clean, and it would duplicate every page |

robots.txt only binds polite crawlers. Scrapers that ignore it are not stopped by blocking AI crawlers either, so
allowing them costs nothing extra. Limits on cost belong in the hosting (e.g. capped concurrency, a budget alert).

### How it works here

- **`PublicPage`** lists the public pages with title and description: one list for the sitemap, llms.txt and the meta descriptions.
- **`CrawlerController`** generates `robots.txt`, `sitemap.xml` and `llms.txt`. They are generated, not static files,
  because they need absolute URLs.
- **`site.base-url`** (`SITE_BASE_URL`) is the site's public address. Absolute links use it, not the request's host,
  so they always name the public address, however the request arrived.
- **`layout/page.jte`** takes `description`, `canonicalUrl` and `noindex` and writes the tags into `<head>`.
- **`SecurityConfig`** protects only the listed pages (`/secured`), so the three files are public. If a site makes
  pages login-only by default instead, they must be listed as public, or crawlers get the sign-in page.

A new public page: add it to `PublicPage`, then pass `description` and `canonicalUrl` in its template (see `about.jte`).
A page that shouldn't be indexed passes `noindex = true`.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 25 |
| Server | Spring Boot 4.1 |
| Templates | JTE 3.2.4 |
| Styling | Tailwind CSS v4 |
| Font | Syne + DM Sans (Google Fonts) |
| Build | Maven (wrapper included) |

---

## Deployment

The app is a plain Spring Boot jar (`mvnw clean package` → `target/beanwind-site.jar`) and can run anywhere Java 25 runs.
Platform-specific deployment notes live under [`deploy/`](deploy/):

| Target | Notes |
|---|---|
| AWS Lambda (current) | [`deploy/aws-lambda/README.md`](deploy/aws-lambda/README.md) |
| Google Cloud Run (previous) | [`deploy/cloud-run/README.md`](deploy/cloud-run/README.md) |

Every deployment provides these environment variables; the jar itself is the same everywhere:

| Variable | Purpose |
|---|---|
| `SPRING_PROFILES_ACTIVE=prod` | `application.yml` defaults to `dev` for local runs |
| `AUTH_COOKIE_SECRET` | Signs the login cookie, at least 32 characters; the same value on every instance |
| `SITE_BASE_URL` | The site's public address, e.g. `https://beanwind.zeybekyilmazltd.com`, for canonical links, sitemap and llms.txt; defaults to `http://localhost:8080` |

---

## License

[MIT](LICENSE)

---

## Changelog

### October 26, 2026 — Custom domain, search engines and AI crawlers
- The live demo moved to https://beanwind.zeybekyilmazltd.com (the old URL still works).
- Added `robots.txt`, `sitemap.xml` and `llms.txt`; public pages get a meta description, canonical link and Open Graph tags,
  sign-in, secured and error pages get `noindex`. See [Search engines and AI crawlers](#search-engines-and-ai-crawlers).
- New setting `site.base-url` (`SITE_BASE_URL`): the public address used for absolute links.

### October 24, 2026 — Renamed Jarloom → Beanwind
- "Jarloom" turned out to be taken too: a live mobile puzzle game (jarloom.app) and a business at jarloom.com. Why "Beanwind": [`docs/Beanwind-Platform-Proposal.md`](docs/Beanwind-Platform-Proposal.md#18-name).
- Package `com.jarloom` → `com.beanwind`, jar `beanwind-site.jar`, new "BW" favicon, cookies `jl_*` → `bw_*` (visitors sign in and answer the cookie banner again once).
- The GitHub repo moved to `hi-rullah/beanwind-site`; the old URLs redirect. AWS resource names stay unchanged (see `deploy/aws-lambda/README.md`).

### October 24, 2026 — Renamed JavaView → Jarloom
- "JavaView" is already the name of another Java project, and "Java" is an Oracle trademark.
- Package `com.javaview` → `com.jarloom`, jar `jarloom-site.jar`, new "JL" favicon, cookies `jv_*` → `jl_*` (visitors sign in and answer the cookie banner again once).
- The GitHub repo moved to `hi-rullah/jarloom-site`; the old URL redirects. AWS resource names stay unchanged (see `deploy/aws-lambda/README.md`).

### October 22, 2026 — Login on several instances, error page
- Login and CSRF token are kept in cookies instead of the HTTP session, so the app works on any number of instances
  (the login form failed with 403 when a request reached another instance).
- `error.jte` replaces Spring Boot's Whitelabel error page.
- The deployment selects the `prod` profile (`SPRING_PROFILES_ACTIVE`); `application.yml` defaults to `dev`.

### October 16, 2026 — Java 25 / Spring Boot 4 upgrade, deployment moved to `deploy/`
- Upgraded to Java 25, Spring Boot 4.1.1 and JTE 3.2.4 (`jte-spring-boot-starter-4`).
- Added Maven wrapper.
- Replaced Google Cloud Run deployment with AWS Lambda; all deployment files, scripts and notes live in `deploy/`.
- Source moved from Google Cloud Source Repositories to GitHub; default branch renamed `master` → `main`.

### April 22, 2026 — Cloud Run Production Readiness
- Updated JTE to version `3.2.1` and added `jte-maven-plugin` for template precompilation.
- Implemented dynamic port binding using `${PORT:8080}` in `application-prod.yml`.
- Reorganized application configuration into profile-specific files (`application-prod.yml`, `application-dev.yml`).
- Added `.jteroot` to `src/main/jte` for proper JTE template discovery.
- Set `prod` as the default active profile in `application.yml`.
