# JavaView Platform — Full Proposal & Architecture

> A modern, opinionated, Java-first UI framework and runtime platform for server-rendered web applications.
> **No React. No Next.js. No Node.js. Pure Java. Zero downtime. Runtime dynamic.**

---

## 1. The Problem It Solves

The Java ecosystem lacks a modern, lightweight UI framework that:

- Feels as productive as Next.js but stays 100% in Java
- Is simpler and lighter than Vaadin
- Is more opinionated and structured than raw Thymeleaf or JTE
- Allows Java teams to own the full stack without learning TypeScript/JSX
- Supports runtime page creation, dynamic scheduling, and config changes **without restarting the main app**

Java teams today are forced to either:
- Use old, heavy frameworks (JSF, Wicket, Vaadin)
- Learn a completely different ecosystem (React, Next.js, Node.js)
- Use Thymeleaf/JTE with no conventions or structure around it
- Accept downtime whenever a new page or feature is needed in production

**JavaView fills this gap.**

---

## 2. The Vision

```
┌────────────────────────────────────────────────────────────┐
│                    JavaView Platform                       │
│                                                            │
│   Spring Boot + JTE + Tailwind + Alpine.js + HTMX         │
│   + Runtime Page Builder + Dynamic Scheduler               │
│   + Sidecar Compiler Service                               │
│                                                            │
│   Competes with Next.js in productivity                    │
│   Stays 100% in the Java ecosystem                         │
│   Supports PWA out of the box                              │
│   Zero downtime page creation in production                │
└────────────────────────────────────────────────────────────┘
```

---

## 3. Core Technology Stack

| Layer | Technology | Purpose |
|---|---|---|
| Foundation | Spring Boot | Auto-configuration, DI, embedded server |
| Templating | JTE (Java Template Engine) | Fast, type-safe HTML rendering |
| Styling | Tailwind CSS | Utility-first CSS, zero design decisions |
| Interactivity | Alpine.js | Lightweight reactivity without a JS framework |
| Partial Updates | HTMX | HTML over the wire, no full page reloads |
| Charts | Chart.js / ApexCharts | Data visualization via CDN |
| Modals / Alerts | SweetAlert2 | UI dialogs without custom JS |
| Date Pickers | Flatpickr | Lightweight date/time input |
| Tables | DataTables.js | Interactive, sortable, searchable tables |
| PWA | Web App Manifest + Service Worker | Installable, offline-capable app |
| Dynamic Pages | Sidecar Compiler Service | Runtime page creation without main app restart |
| Dynamic Scheduling | Spring TaskScheduler + DB | Runtime job management without restart |
| Dynamic Config | Database-backed config | Runtime configuration without restart |

---

## 4. Architecture

### 4.1 Full Platform Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                        Browser                               │
└───────────────────────────┬──────────────────────────────────┘
                            │ HTTP
                            ▼
┌──────────────────────────────────────────────────────────────┐
│                  Main App (always running)                   │
│                  Spring Boot — Port 8080                     │
│                                                              │
│  - Static pages & core UI         - Auth / Session          │
│  - Layout / Navigation            - Proxy router            │
│  - PWA support                    - Never restarts          │
└────────────┬─────────────────────────────┬───────────────────┘
             │                             │
             ▼                             ▼
┌────────────────────────┐   ┌─────────────────────────────┐
│  Backend API Service   │   │  Controller Sub-Service     │
│  Spring Boot: 8081     │   │  Spring Boot: 8082          │
│                        │   │                             │
│  - REST APIs           │   │  - Dynamic controllers      │
│  - Business Logic      │   │  - New pages at runtime     │
│  - Database / JPA      │   │  - Sidecar compiler         │
│  - Returns JSON only   │   │  - Restarts safely (~2s)    │
└────────────────────────┘   └─────────────────────────────┘
             │
             ▼
┌────────────────────────┐
│  Database              │
│  PostgreSQL            │
│  - Pages               │
│  - Scheduled jobs      │
│  - Dynamic config      │
└────────────────────────┘
```

### 4.2 Three-Tier Summary

```
Browser → Main App (JavaView UI) → Backend API → Database
           HTML + CSS + JS          REST / JSON    PostgreSQL
```

---

## 5. Project Structure Convention

```
my-ui-app/
├── src/main/java/com/myapp/
│   ├── pages/                      ← auto-mapped to URL routes
│   │   ├── HomePage.java           → GET /
│   │   ├── DashboardPage.java      → GET /dashboard
│   │   └── users/
│   │       ├── UserListPage.java   → GET /users
│   │       └── UserDetailPage.java → GET /users/{id}
│   ├── components/                 ← reusable page fragments
│   ├── layouts/                    ← base layout definitions
│   ├── client/                     ← backend API clients (WebClient)
│   ├── dynamic/                    ← runtime generated controllers
│   └── config/                     ← framework configuration
├── src/main/jte/
│   ├── pages/                      ← JTE templates per page
│   ├── components/                 ← reusable JTE components
│   ├── dynamic/                    ← templates for dynamic pages
│   └── layouts/                    ← layout templates
└── src/main/resources/
    ├── static/
    │   ├── css/output.css          ← compiled Tailwind CSS
    │   ├── js/                     ← custom JS files
    │   ├── manifest.json           ← PWA manifest
    │   ├── service-worker.js       ← PWA service worker
    │   └── icons/                  ← PWA icons
    └── application.yml
```

---

## 6. PWA Support — Built In

JavaView includes PWA support out of the box. No configuration needed.

### manifest.json
```json
{
  "name": "MyApp",
  "short_name": "MyApp",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#3b82f6",
  "icons": [
    { "src": "/icons/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icons/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

### service-worker.js
```javascript
const CACHE_NAME = 'javaview-v1';
const ASSETS = ['/', '/css/output.css', '/js/main.js', '/offline.html'];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(ASSETS))
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(cached => cached || fetch(event.request))
      .catch(() => caches.match('/offline.html'))
  );
});
```

### Auto-registered in base JTE layout
```html
<!DOCTYPE html>
<html>
<head>
    <link rel="manifest" href="/manifest.json">
    <meta name="theme-color" content="#3b82f6">
    <link rel="stylesheet" href="/css/output.css">
</head>
<body>
    <%-- page content --%>
    <script>
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.register('/service-worker.js');
        }
    </script>
</body>
</html>
```

### PWA Features Available

| Feature | How |
|---|---|
| Installable (Add to Home Screen) | manifest.json |
| Offline support | Service Worker cache-first strategy |
| Fast repeat visits | Service Worker caching |
| Push notifications | Web Push API + service worker |
| Background sync | Background Sync API |
| App-like feel | `display: standalone` in manifest |

---

## 7. Runtime Dynamism — The Sidecar Compiler Pattern

This is the most innovative part of JavaView. Instead of requiring a full app restart when a new page or controller is needed in production, JavaView uses a **dedicated Controller Sub-Service** that can restart independently without affecting the main app.

### 7.1 How It Works — New Page in Production

```
Admin fills "New Page" form in Main App
        ↓
Main App sends page definition to Controller Sub-Service API
        ↓
Sub-Service generates Java controller source code
        ↓
Sub-Service compiles it using JavaCompiler API
        ↓
Sub-Service restarts itself only (~2 seconds)
        ↓
Main App updates its proxy routing table
        ↓
New page is live — Main App never restarted
```

### 7.2 Main App — Proxy Router

```java
@Controller
public class DynamicProxyController {

    @Autowired
    private SubServiceRegistry registry;

    @Autowired
    private WebClient webClient;

    @GetMapping("/dynamic/**")
    public ResponseEntity<String> proxyToDynamic(HttpServletRequest request) {
        try {
            String subServiceUrl = registry.getUrl(); // http://localhost:8082
            return webClient.get()
                .uri(subServiceUrl + request.getRequestURI())
                .retrieve()
                .toEntity(String.class)
                .block();

        } catch (Exception e) {
            // Sub-service is restarting — auto retry after 3s
            return ResponseEntity.ok("""
                <div class="flex items-center justify-center h-64">
                    <div class="text-center">
                        <p class="text-gray-500">Page is being prepared...</p>
                        <script>setTimeout(() => location.reload(), 3000);</script>
                    </div>
                </div>
            """);
        }
    }
}
```

### 7.3 Controller Sub-Service — Runtime Compiler

```java
@RestController
@RequestMapping("/compiler")
public class CompilerController {

    @Autowired
    private JavaCompilerService compilerService;

    @PostMapping("/page")
    public ResponseEntity<?> addNewPage(@RequestBody PageDefinition def) {
        // 1. Generate controller source
        String sourceCode = compilerService.generateController(def);

        // 2. Write and compile
        compilerService.writeSourceFile(def.getClassName(), sourceCode);
        compilerService.compile(def.getClassName());

        // 3. Schedule self-restart (only this sub-service)
        compilerService.scheduleRestart();

        return ResponseEntity.ok("Page queued — sub-service restarting");
    }
}

@Service
public class JavaCompilerService {

    public void compile(String className) {
        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        int result = compiler.run(null, null, null,
            "src/main/java/dynamic/" + className + ".java"
        );
        if (result != 0) throw new CompilationException("Compile failed: " + className);
    }

    public String generateController(PageDefinition def) {
        return """
            @Controller
            public class %sController {
                @GetMapping("%s")
                public String render(Model model) {
                    model.addAttribute("title", "%s");
                    model.addAttribute("config", %s);
                    return "dynamic/%s";
                }
            }
            """.formatted(
                def.getName(), def.getPath(),
                def.getTitle(), def.getConfigJson(),
                def.getTemplate()
            );
    }

    public void scheduleRestart() {
        new Thread(() -> {
            try {
                Thread.sleep(2000); // allow HTTP response to return first
                SpringApplication.exit(applicationContext, () -> 0);
                // Docker/systemd auto-restarts the sub-service
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }).start();
    }
}
```

---

## 8. Dynamic Scheduler — Runtime Job Management

No `@Scheduled` annotations needed. Jobs live in the database and are managed at runtime.

```java
@Service
public class DynamicSchedulerService {

    @Autowired
    private TaskScheduler taskScheduler;

    @Autowired
    private JobRepository jobRepository;

    private final Map<UUID, ScheduledFuture<?>> runningJobs = new ConcurrentHashMap<>();

    public void startJob(ScheduledJob job) {
        ScheduledFuture<?> future = taskScheduler.schedule(
            () -> executeJob(job),
            new CronTrigger(job.getCronExpression())
        );
        runningJobs.put(job.getId(), future);
    }

    public void stopJob(UUID jobId) {
        ScheduledFuture<?> future = runningJobs.get(jobId);
        if (future != null) {
            future.cancel(false);
            runningJobs.remove(jobId);
        }
    }

    public void updateJob(UUID jobId, String newCronExpression) {
        stopJob(jobId);
        ScheduledJob job = jobRepository.findById(jobId).orElseThrow();
        job.setCronExpression(newCronExpression);
        jobRepository.save(job);
        startJob(job);
    }
}
```

Database schema:
```sql
CREATE TABLE scheduled_jobs (
    id UUID PRIMARY KEY,
    name VARCHAR(255),
    cron_expression VARCHAR(100),
    job_type VARCHAR(100),
    config JSONB,
    is_active BOOLEAN,
    last_run TIMESTAMP,
    next_run TIMESTAMP
);
```

Admin changes cron expression → `updateJob()` called → new schedule active instantly. **No restart.**

---

## 9. Dynamic Configuration — Runtime Config Management

```java
@Service
public class DynamicConfigService {

    @Autowired
    private ConfigRepository configRepository;

    private final Map<String, String> cache = new ConcurrentHashMap<>();

    public String get(String key) {
        return cache.computeIfAbsent(key,
            k -> configRepository.findByKey(k)
                .map(ConfigEntry::getValue)
                .orElse(null));
    }

    public void update(String key, String value) {
        configRepository.save(new ConfigEntry(key, value));
        cache.remove(key); // next read picks up new value immediately
    }
}
```

Admin updates any config value → cache invalidated → new value takes effect instantly. **No restart.**

---

## 10. What Requires Restart vs What Doesn't

| Change Type | Default Spring Boot | JavaView |
|---|---|---|
| Favicon / icons / static files | No restart needed | No restart needed |
| JTE templates | No restart needed | No restart needed |
| CSS / JS files | No restart needed | No restart needed |
| App configuration | Restart needed | No restart — DB config |
| New scheduled job | Restart needed | No restart — Dynamic Scheduler |
| New page / controller | Restart needed | ~2s — Sidecar Sub-Service only |
| Core framework changes | Restart needed | Restart needed |

---

## 11. Deployment Architecture

```yaml
# docker-compose.yml
services:
  main-app:
    image: javaview-main
    ports:
      - "8080:8080"
    restart: "no"           # main app never auto-restarts

  controller-service:
    image: javaview-controllers
    ports:
      - "8082:8082"
    restart: always         # always auto-restarts after JVM exit
    volumes:
      - ./dynamic-pages:/app/dynamic

  backend-api:
    image: myapp-backend
    ports:
      - "8081:8081"
    restart: always

  database:
    image: postgres:16
    environment:
      POSTGRES_DB: javaview
      POSTGRES_USER: app
      POSTGRES_PASSWORD: secret
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

---

## 12. Comparison with Alternatives

| Feature | Next.js | Vaadin | Thymeleaf | **JavaView** |
|---|---|---|---|---|
| Language | TypeScript | Java | Java | **Java** |
| Templating | JSX | Java API | HTML+dialect | **JTE (type-safe)** |
| Styling | Any | Built-in | Any | **Tailwind (built-in)** |
| Routing | File-based | Auto | Manual | **Convention-based** |
| Interactivity | React | Java events | Manual JS | **Alpine.js + HTMX** |
| PWA Support | ✅ | ❌ | Manual | **✅ Built-in** |
| Runtime new pages | ✅ | ❌ | ❌ | **✅ Sidecar pattern** |
| Runtime scheduler | ❌ | ❌ | ❌ | **✅ Dynamic scheduler** |
| Runtime config | ⚠️ | ❌ | ❌ | **✅ DB-backed config** |
| Backend client | Manual | N/A | Manual | **Built-in** |
| Deployment | Node.js server | JAR | JAR | **JAR** |
| License | MIT | Mixed (RSAL) | Apache 2.0 | **Apache 2.0** |

---

## 13. MVP Roadmap

### Phase 1 — Core Framework (v0.1)
- [ ] Spring Boot starter (`spring-boot-starter-javaview`)
- [ ] JTE auto-configuration
- [ ] Tailwind CLI integration at build time
- [ ] `@Page` annotation for convention-based routing
- [ ] `@Layout` annotation support
- [ ] Base layout system
- [ ] Alpine.js and HTMX auto-included

### Phase 2 — Developer Experience (v0.2)
- [ ] Maven archetype / Gradle template for scaffolding
- [ ] `javaview new my-app` CLI tool
- [ ] Hot reload with Spring DevTools pre-configured
- [ ] JTE development mode enabled by default
- [ ] `@BackendService` interface-based HTTP client
- [ ] PWA manifest + service worker auto-generated

### Phase 3 — Runtime Dynamism (v0.3)
- [ ] Sidecar Controller Sub-Service
- [ ] Runtime page creation via admin UI
- [ ] Java source code generator
- [ ] JavaCompiler API integration
- [ ] Proxy routing in main app
- [ ] Graceful sub-service restart handling

### Phase 4 — Dynamic Platform Features (v0.4)
- [ ] Dynamic Scheduler (DB-driven cron jobs)
- [ ] Dynamic Config Service
- [ ] Admin dashboard for managing pages, jobs, config
- [ ] Built-in JTE component library (cards, tables, forms, navbars)
- [ ] Tailwind theme system / design tokens

### Phase 5 — Production Ready (v1.0)
- [ ] Spring Security integration (session auth out of the box)
- [ ] i18n / localization support
- [ ] Comprehensive documentation site
- [ ] Example projects (dashboard, CRM, admin panel, PWA app)
- [ ] GitHub Actions CI/CD templates
- [ ] Docker Compose templates

---

## 14. Philosophy & Principles

1. **Java first** — if you know Spring Boot, you know JavaView
2. **Convention over configuration** — sensible defaults, minimal setup
3. **HTML over the wire** — server renders, browser displays
4. **No JavaScript framework** — JS is a tool, not a religion
5. **Simplicity** — one JAR, one deployment, one language
6. **Zero downtime** — runtime dynamism without restarting the main app
7. **PWA ready** — installable, offline-capable by default
8. **Productive by default** — Tailwind + Alpine.js + HTMX included and ready

---

## 15. What JavaView Is NOT

- Not a replacement for React when building SPAs like Notion or Figma
- Not suitable for apps needing deep native device API access
- Not a low-code drag-and-drop platform (though it could evolve that way)
- Not adding a Node.js runtime — ever

---

## 16. Ideal Use Cases

JavaView is a perfect fit for:

- ✅ Internal tools and admin dashboards
- ✅ B2B SaaS applications
- ✅ Enterprise CRUD applications
- ✅ ERP / CRM / HR portals
- ✅ Reporting and analytics dashboards
- ✅ Installable PWA business apps
- ✅ Any app where the team is Java-first
- ✅ Replacing legacy JSF, Struts, Wicket, or Vaadin apps
- ✅ Apps requiring runtime page/feature management without redeployment

---

## 17. Inspiration & Philosophy References

- **Hotwire (Rails)** — HTML over the wire philosophy
- **Laravel Livewire** — server-driven UI components
- **Next.js** — file-based routing conventions
- **Spring Boot** — convention over configuration for Java
- **htmx.org** — "you can build modern UIs without a JS framework"
- **Sidecar Pattern** — microservice pattern for isolated, restartable sub-services

---

## 18. Suggested Name Options

| Name | Reasoning |
|---|---|
| **JavaView** | Clear, Java + View layer |
| **JteStack** | Highlights the core templating engine |
| **SpringLeaf** | Spring + lightweight (like a leaf) |
| **Fernwork** | Organic, modern sounding framework name |
| **Verano** | Suggests "spring" in other languages, modern feel |

---

*JavaView is more than a UI framework — it is a Java-native platform for building modern, dynamic, installable web applications without leaving the Java ecosystem. The sidecar compiler pattern solves the last major limitation of server-rendered Java apps: the ability to evolve in production without downtime.*
