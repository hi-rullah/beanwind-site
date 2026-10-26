@import com.beanwind.page.PublicPage
@import com.beanwind.page.SiteProperties
@import com.beanwind.security.CurrentUser
@param CurrentUser currentUser
@param SiteProperties site

@template.layout.page(
    title = "About — Beanwind",
    page = "about",
    active = "about",
    currentUser = currentUser,
    description = PublicPage.ABOUT.description(),
    canonicalUrl = site.url(PublicPage.ABOUT.path()),
    style = @`
    <style>
        .gradient-text {
            background: linear-gradient(135deg, #f59e0b, #ef4444, #ec4899);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .hero-glow {
            background: radial-gradient(ellipse 70% 40% at 50% 0%, rgba(245,158,11,0.1), transparent);
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .fade-up { animation: fadeUp 0.6s ease forwards; }
        .delay-1 { animation-delay: 0.1s; opacity: 0; }
        .delay-2 { animation-delay: 0.2s; opacity: 0; }
        .delay-3 { animation-delay: 0.35s; opacity: 0; }
        .delay-4 { animation-delay: 0.5s; opacity: 0; }
    </style>
    `,
    content = @`
    <!-- Hero -->
    <section class="hero-glow pt-40 pb-20 px-6 text-center">
        <div class="max-w-3xl mx-auto">
            <div class="fade-up delay-1 inline-block mb-6 px-4 py-1.5 rounded-full border border-amber-500/30 bg-amber-500/10 text-amber-400 text-xs font-semibold tracking-widest uppercase">
                Our Story
            </div>
            <h1 class="fade-up delay-2 font-display text-[10vw] sm:text-6xl md:text-7xl font-extrabold leading-none mb-6 tracking-tight">
                Why <span class="gradient-text">Beanwind</span>
            </h1>
            <p class="fade-up delay-3 text-zinc-400 text-xl font-light leading-relaxed">
                We believe Java teams shouldn't have to learn an entirely different ecosystem just to build a great UI. Beanwind brings modern web design to the JVM — no compromise.
            </p>
            <div class="fade-up delay-4 mt-10">
                <a href="#architecture" class="inline-block px-8 py-3.5 border border-zinc-700 hover:border-zinc-500 text-zinc-300 font-semibold rounded-full transition-all duration-200">
                    See Architecture
                </a>
            </div>
        </div>
    </section>

    <!-- Story -->
    <section class="py-20 px-6">
        <div class="max-w-3xl mx-auto space-y-16">

            <!-- Block 1 -->
            <div class="flex gap-8 items-start">
                <div class="shrink-0 w-14 h-14 rounded-2xl bg-amber-500/10 border border-amber-500/20 flex items-center justify-center text-2xl">🧩</div>
                <div>
                    <h3 class="font-display text-2xl font-bold mb-3">The Problem</h3>
                    <p class="text-zinc-400 leading-relaxed">Java teams have been forced to choose between heavyweight frameworks like Vaadin and JSF, or abandoning Java entirely for React and Next.js. Neither option felt right. One was too complex, the other too foreign.</p>
                </div>
            </div>

            <!-- Divider -->
            <div class="border-t border-zinc-800"></div>

            <!-- Block 2 -->
            <div class="flex gap-8 items-start">
                <div class="shrink-0 w-14 h-14 rounded-2xl bg-rose-500/10 border border-rose-500/20 flex items-center justify-center text-2xl">💡</div>
                <div>
                    <h3 class="font-display text-2xl font-bold mb-3">The Idea</h3>
                    <p class="text-zinc-400 leading-relaxed">What if a Java team could build a stunning, modern web UI using only the tools they already know — Spring Boot, Java, and HTML? Add Tailwind for beautiful design and JTE for type-safe templates, and you have everything you need.</p>
                </div>
            </div>

            <!-- Divider -->
            <div class="border-t border-zinc-800"></div>

            <!-- Block 3 -->
            <div class="flex gap-8 items-start">
                <div class="shrink-0 w-14 h-14 rounded-2xl bg-pink-500/10 border border-pink-500/20 flex items-center justify-center text-2xl">🚀</div>
                <div>
                    <h3 class="font-display text-2xl font-bold mb-3">The Result</h3>
                    <p class="text-zinc-400 leading-relaxed">A clean, opinionated stack that deploys as a single JAR, requires zero npm packages, and lets a Java team own the entire application — front to back — in one language they love.</p>
                </div>
            </div>

        </div>
    </section>

    <!-- Architecture -->
    <section id="architecture" class="py-20 px-6 border-t border-zinc-800 scroll-mt-16">
        <div class="max-w-5xl mx-auto">
            <div class="text-center mb-14">
                <div class="inline-block mb-6 px-4 py-1.5 rounded-full border border-amber-500/30 bg-amber-500/10 text-amber-400 text-xs font-semibold tracking-widest uppercase">
                    Architecture
                </div>
                <h2 class="font-display text-3xl md:text-4xl font-bold mb-4">How Beanwind Works</h2>
                <p class="text-zinc-400 leading-relaxed max-w-2xl mx-auto">
                    Beanwind is the presentation tier of a classic three-tier application. It renders every page as HTML on the server, so the browser gets a finished page and no JavaScript framework is involved.
                </p>
            </div>

            <!-- Diagram: stacks vertically on phones, runs left to right on large screens -->
            <div class="flex flex-col lg:flex-row lg:items-stretch items-center gap-2" role="img" aria-label="Browser exchanges HTML with the Beanwind app, where Spring Security checks each request before a controller renders the page; the app calls a separate backend service over REST, which stores data in a database">

                <!-- Browser -->
                <div class="w-full max-w-sm lg:w-36 lg:max-w-none shrink-0 bg-zinc-900 border border-zinc-700 rounded-2xl p-5 text-center flex flex-col justify-center">
                    <div class="text-2xl mb-2">🌐</div>
                    <div class="font-display font-bold">Browser</div>
                    <div class="text-zinc-500 text-xs mt-1">Phone or desktop</div>
                </div>

                <div class="flex lg:flex-col items-center justify-center gap-2 text-zinc-500 text-xs lg:px-1">
                    <span class="text-lg text-amber-400 lg:hidden">⇅</span>
                    <span class="text-lg text-amber-400 hidden lg:inline">⇄</span>
                    <span class="font-mono">HTTP · HTML</span>
                </div>

                <!-- This app -->
                <div class="w-full max-w-sm lg:max-w-none lg:flex-1 bg-zinc-900 border-2 border-amber-500/50 rounded-2xl p-5">
                    <div class="flex items-center justify-between gap-2 mb-4">
                        <div class="font-display font-bold">Beanwind app</div>
                        <span class="text-[10px] uppercase tracking-wider text-amber-400 border border-amber-500/30 rounded-full px-2 py-0.5">This site</span>
                    </div>
                    <ol class="space-y-2 text-sm">
                        <li class="bg-zinc-950 border border-emerald-500/30 rounded-lg px-3 py-2">
                            <span class="text-zinc-200 font-medium">🔒 Spring Security</span>
                            <span class="block text-zinc-500 text-xs">Checks every request: login, session, CSRF</span>
                        </li>
                        <li class="bg-zinc-950 border border-zinc-800 rounded-lg px-3 py-2">
                            <span class="text-zinc-200 font-medium">Spring MVC controller</span>
                            <span class="block text-zinc-500 text-xs">Maps the URL and picks a template</span>
                        </li>
                        <li class="bg-zinc-950 border border-zinc-800 rounded-lg px-3 py-2">
                            <span class="text-zinc-200 font-medium">JTE template</span>
                            <span class="block text-zinc-500 text-xs">Type-safe, precompiled to Java classes</span>
                        </li>
                        <li class="bg-zinc-950 border border-zinc-800 rounded-lg px-3 py-2">
                            <span class="text-zinc-200 font-medium">Tailwind CSS</span>
                            <span class="block text-zinc-500 text-xs">One static file, built ahead of time</span>
                        </li>
                        <li class="bg-zinc-950 border border-dashed border-zinc-700 rounded-lg px-3 py-2">
                            <span class="text-zinc-200 font-medium">RestClient</span>
                            <span class="block text-zinc-500 text-xs">Ready to fetch data from the backend</span>
                        </li>
                    </ol>
                    <div class="text-zinc-500 text-xs mt-4 text-center">Spring Boot 4 · Java 25 · single JAR</div>
                </div>

                <div class="flex lg:flex-col items-center justify-center gap-2 text-zinc-500 text-xs lg:px-1">
                    <span class="text-lg text-zinc-500 lg:hidden">↓</span>
                    <span class="text-lg text-zinc-500 hidden lg:inline">→</span>
                    <span class="font-mono">REST · JSON</span>
                </div>

                <!-- Backend (planned) -->
                <div class="w-full max-w-sm lg:w-40 lg:max-w-none shrink-0 border border-dashed border-zinc-700 rounded-2xl p-5 text-center flex flex-col justify-center">
                    <div class="text-2xl mb-2">⚙️</div>
                    <div class="font-display font-bold text-zinc-300">Backend service</div>
                    <div class="text-zinc-500 text-xs mt-1">Business logic and REST API, in a separate repository</div>
                </div>

                <div class="flex lg:flex-col items-center justify-center gap-2 text-zinc-500 text-xs lg:px-1">
                    <span class="text-lg lg:hidden">↓</span>
                    <span class="text-lg hidden lg:inline">→</span>
                    <span class="font-mono">SQL</span>
                </div>

                <!-- Database (planned) -->
                <div class="w-full max-w-sm lg:w-32 lg:max-w-none shrink-0 border border-dashed border-zinc-700 rounded-2xl p-5 text-center flex flex-col justify-center">
                    <div class="text-2xl mb-2">🗄️</div>
                    <div class="font-display font-bold text-zinc-300">Database</div>
                    <div class="text-zinc-500 text-xs mt-1">Owned by the backend</div>
                </div>
            </div>

            <!-- Legend -->
            <div class="flex flex-wrap justify-center gap-x-6 gap-y-2 mt-8 text-xs text-zinc-500">
                <span class="flex items-center gap-2"><span class="w-4 h-3 rounded border-2 border-amber-500/50"></span>Live in this project</span>
                <span class="flex items-center gap-2"><span class="w-4 h-3 rounded border border-dashed border-zinc-600"></span>Planned, not built yet</span>
            </div>

            <!-- Request lifecycle -->
            <h3 class="font-display text-2xl font-bold text-center mt-20 mb-10">The Life of a Request</h3>
            <ol class="grid sm:grid-cols-2 lg:grid-cols-5 gap-4">
                <li class="bg-zinc-900 border border-zinc-800 rounded-xl p-5">
                    <div class="font-display text-amber-400 font-bold mb-2">01</div>
                    <div class="font-semibold mb-1">You open a page</div>
                    <p class="text-zinc-400 text-sm leading-relaxed">The browser sends a plain GET request, for example <code class="text-zinc-300">/about</code>.</p>
                </li>
                <li class="bg-zinc-900 border border-zinc-800 rounded-xl p-5">
                    <div class="font-display text-emerald-400 font-bold mb-2">02</div>
                    <div class="font-semibold mb-1">Spring Security checks it</div>
                    <p class="text-zinc-400 text-sm leading-relaxed">Public pages pass straight through. <code class="text-zinc-300">/secured</code> sends you to sign in first.</p>
                </li>
                <li class="bg-zinc-900 border border-zinc-800 rounded-xl p-5">
                    <div class="font-display text-orange-400 font-bold mb-2">03</div>
                    <div class="font-semibold mb-1">A controller answers</div>
                    <p class="text-zinc-400 text-sm leading-relaxed">A Spring MVC controller handles the URL. Later it can ask the backend for data.</p>
                </li>
                <li class="bg-zinc-900 border border-zinc-800 rounded-xl p-5">
                    <div class="font-display text-rose-400 font-bold mb-2">04</div>
                    <div class="font-semibold mb-1">JTE renders HTML</div>
                    <p class="text-zinc-400 text-sm leading-relaxed">The template turns Java objects into HTML. Typos fail at compile time, not in front of users.</p>
                </li>
                <li class="bg-zinc-900 border border-zinc-800 rounded-xl p-5">
                    <div class="font-display text-pink-400 font-bold mb-2">05</div>
                    <div class="font-semibold mb-1">The page arrives ready</div>
                    <p class="text-zinc-400 text-sm leading-relaxed">The browser shows finished HTML styled by one small CSS file. No client-side rendering.</p>
                </li>
            </ol>

            <!-- Principles -->
            <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-4 mt-12 text-sm">
                <div class="border-l-2 border-amber-500/50 pl-4">
                    <div class="font-semibold mb-1">Thin controllers</div>
                    <p class="text-zinc-400 leading-relaxed">Controllers fetch data and choose a template. Business rules belong in the backend.</p>
                </div>
                <div class="border-l-2 border-rose-500/50 pl-4">
                    <div class="font-semibold mb-1">No database here</div>
                    <p class="text-zinc-400 leading-relaxed">The frontend never talks to a database directly. It asks the backend over HTTP.</p>
                </div>
                <div class="border-l-2 border-pink-500/50 pl-4">
                    <div class="font-semibold mb-1">No Node.js at runtime</div>
                    <p class="text-zinc-400 leading-relaxed">Tailwind is compiled once during development. Production runs only the JVM.</p>
                </div>
                <div class="border-l-2 border-emerald-500/50 pl-4">
                    <div class="font-semibold mb-1">Proven security</div>
                    <p class="text-zinc-400 leading-relaxed">Sign-in, sessions and CSRF protection come from Spring Security, not home-made code.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Tech Stack -->
    <section class="py-20 px-6 bg-zinc-900/40 border-y border-zinc-800">
        <div class="max-w-5xl mx-auto">
            <h2 class="font-display text-3xl font-bold text-center mb-12">The Stack</h2>
            <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
                <a href="https://spring.io/projects/spring-boot/" target="_blank" rel="noopener noreferrer"
                   class="block bg-zinc-900 border border-zinc-800 hover:border-zinc-600 rounded-xl p-6 text-center transition-colors">
                    <div class="text-3xl mb-3">🍃</div>
                    <div class="font-display font-bold mb-1">Spring Boot</div>
                    <div class="text-zinc-500 text-xs">Foundation</div>
                    <div class="text-zinc-400 text-xs mt-3">spring.io <span aria-hidden="true">↗</span><span class="sr-only">(opens in a new tab)</span></div>
                </a>
                <a href="https://spring.io/projects/spring-security/" target="_blank" rel="noopener noreferrer"
                   class="block bg-zinc-900 border border-zinc-800 hover:border-zinc-600 rounded-xl p-6 text-center transition-colors">
                    <div class="text-3xl mb-3">🔒</div>
                    <div class="font-display font-bold mb-1">Spring Security</div>
                    <div class="text-zinc-500 text-xs">Security</div>
                    <div class="text-zinc-400 text-xs mt-3">spring.io <span aria-hidden="true">↗</span><span class="sr-only">(opens in a new tab)</span></div>
                </a>
                <a href="https://jte.gg/" target="_blank" rel="noopener noreferrer"
                   class="block bg-zinc-900 border border-zinc-800 hover:border-zinc-600 rounded-xl p-6 text-center transition-colors">
                    <div class="text-3xl mb-3">📄</div>
                    <div class="font-display font-bold mb-1">JTE</div>
                    <div class="text-zinc-500 text-xs">Templates</div>
                    <div class="text-zinc-400 text-xs mt-3">jte.gg <span aria-hidden="true">↗</span><span class="sr-only">(opens in a new tab)</span></div>
                </a>
                <a href="https://tailwindcss.com/" target="_blank" rel="noopener noreferrer"
                   class="block bg-zinc-900 border border-zinc-800 hover:border-zinc-600 rounded-xl p-6 text-center transition-colors">
                    <div class="text-3xl mb-3">🎨</div>
                    <div class="font-display font-bold mb-1">Tailwind</div>
                    <div class="text-zinc-500 text-xs">Styling</div>
                    <div class="text-zinc-400 text-xs mt-3">tailwindcss.com <span aria-hidden="true">↗</span><span class="sr-only">(opens in a new tab)</span></div>
                </a>
                <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript" target="_blank" rel="noopener noreferrer"
                   class="col-span-2 md:col-span-1 block bg-zinc-900 border border-zinc-800 hover:border-zinc-600 rounded-xl p-6 text-center transition-colors">
                    <div class="text-3xl mb-3">⚡</div>
                    <div class="font-display font-bold mb-1">Vanilla JS</div>
                    <div class="text-zinc-500 text-xs">Interactivity</div>
                    <div class="text-zinc-400 text-xs mt-3">MDN <span aria-hidden="true">↗</span><span class="sr-only">(opens in a new tab)</span></div>
                </a>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="py-24 px-6 text-center">
        <h2 class="font-display text-4xl font-bold mb-6">Let's Build Something</h2>
        <p class="text-zinc-400 mb-10">Start simple. Stay Java. Ship fast.</p>
        <a href="/" class="inline-block px-10 py-4 bg-gradient-to-r from-amber-500 to-rose-500 text-zinc-950 font-bold rounded-full hover:scale-105 transition-transform duration-200">
            ← Back to Home
        </a>
    </section>
`)
