# JavaView Site

A simple company landing page built with **Spring Boot + JTE + Tailwind CSS v4**.
No React. No Node.js. No npm. Pure Java.

---

## Prerequisites

- Java 17+
- Maven 3.8+

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
mvn spring-boot:run
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
mvn spring-boot:run
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
│   └── controller/
│       └── PageController.java           ← page route mappings
├── src/main/jte/
│   ├── index.jte                         ← Home page
│   └── about.jte                         ← About page
├── src/main/resources/
│   ├── static/
│   │   ├── css/output.css                ← compiled Tailwind (generated)
│   │   └── favicon.ico                   ← optional site icon
│   └── application.yml                   ← app config
├── input.css                             ← Tailwind v4 entry point
├── tailwind-build.bat                    ← build CSS once (Windows)
├── tailwind-watch.bat                    ← watch CSS changes (Windows)
└── pom.xml
```

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

## Favicon 404

The browser looks for `/favicon.ico` automatically. To remove the 404 warning in the console, add any `.ico` file here:
```
src/main/resources/static/favicon.ico
```

Generate a free one at: https://favicon.io

---

## Tech Stack

| Layer | Technology |
|---|---|
| Server | Spring Boot 3.2 |
| Templates | JTE 3.1.9 |
| Styling | Tailwind CSS v4 |
| Font | Syne + DM Sans (Google Fonts) |
| Deployment | Single JAR |
