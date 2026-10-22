# JavaView Site

A simple company landing page built with **Spring Boot + JTE + Tailwind CSS v4**.
No React. No Node.js. No npm. Pure Java.

---

## Architecture

This repo is the **frontend (presentation) tier** of a three-tier application — it contains no backend business logic and no database access.

```
Browser ──▶ javaview-site (THIS REPO)  ──REST──▶  Backend service  ──▶  Database
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
javaview-site/
├── src/main/java/com/javaview/
│   ├── Application.java                  ← Spring Boot entry point
│   ├── config/
│   │   ├── BackendProperties.java        ← backend.* settings
│   │   ├── BackendClientConfig.java      ← RestClient for the backend service
│   │   └── SecurityConfig.java           ← Spring Security: public pages, demo user, (commented) OAuth2
│   ├── page/
│   │   └── PageController.java           ← page route mappings
│   └── security/
│       ├── CurrentUser.java              ← logged-in user as the templates see it
│       └── CurrentUserAdvice.java        ← adds currentUser to every page's model
├── src/main/jte/
│   ├── layout/
│   │   ├── page.jte                      ← shared page layout: <head>, navbar, content, footer
│   │   ├── navbar.jte                    ← shared navbar (included by page.jte)
│   │   └── footer.jte                    ← shared footer, year from Year.now() (included by page.jte)
│   ├── index.jte                         ← Home page
│   ├── about.jte                         ← About page
│   ├── login.jte                         ← Sign-in page (demo / demo)
│   └── secured.jte                       ← Page that requires login
├── src/main/resources/
│   ├── static/
│   │   ├── css/output.css                ← compiled Tailwind (generated)
│   │   ├── js/                           ← one script per page: index.js, about.js, login.js, secured.js
│   │   ├── fonts/                        ← self-hosted Syne + DM Sans (.woff2)
│   │   └── images/                       ← images; favicon/ holds favicons + site.webmanifest
│   └── application.yml                   ← app config (+ application-dev/prod.yml)
├── docs/architecture.md                  ← three-tier design, backend, secrets, security guide
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
  A new page `contact.jte` gets `js/contact.js`.
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

The app is a plain Spring Boot jar (`mvnw clean package` → `target/javaview-site.jar`) and can run anywhere Java 25 runs.
Platform-specific deployment notes live under [`deploy/`](deploy/):

| Target | Notes |
|---|---|
| AWS Lambda (current) | [`deploy/aws-lambda/README.md`](deploy/aws-lambda/README.md) |
| Google Cloud Run (previous) | [`deploy/cloud-run/README.md`](deploy/cloud-run/README.md) |

---

## Changelog

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
