@import com.jarloom.security.CurrentUser
@param CurrentUser currentUser

@template.layout.page(
    title = "Jarloom — One JAR. Whole UI.",
    page = "index",
    active = "home",
    currentUser = currentUser,
    style = @`
    <style>
        .gradient-text {
            background: linear-gradient(135deg, #34d399, #06b6d4, #818cf8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .hero-glow {
            background: radial-gradient(ellipse 80% 50% at 50% -10%, rgba(52,211,153,0.15), transparent);
        }
        .card-hover {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .card-hover:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(24px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .fade-up { animation: fadeUp 0.7s ease forwards; }
        .delay-1 { animation-delay: 0.1s; opacity: 0; }
        .delay-2 { animation-delay: 0.25s; opacity: 0; }
        .delay-3 { animation-delay: 0.4s; opacity: 0; }
        .delay-4 { animation-delay: 0.55s; opacity: 0; }
    </style>
    `,
    content = @`
    <!-- Hero -->
    <section class="hero-glow min-h-screen flex items-center justify-center px-6 pt-20">
        <div class="max-w-4xl mx-auto text-center">
            <div class="fade-up delay-1 inline-block mb-6 px-4 py-1.5 rounded-full border border-emerald-500/30 bg-emerald-500/10 text-emerald-400 text-xs font-semibold tracking-widest uppercase">
                Spring Boot + JTE + Tailwind
            </div>
            <h1 class="fade-up delay-2 font-display text-[10vw] sm:text-6xl md:text-8xl font-extrabold leading-none mb-6 tracking-tight">
                Build Beautiful<br>
                <span class="gradient-text">Java Web Apps</span>
            </h1>
            <p class="fade-up delay-3 font-display text-xl md:text-2xl font-bold text-emerald-400 tracking-tight mb-6">
                One JAR. Whole UI.
            </p>
            <p class="fade-up delay-3 text-zinc-400 text-xl md:text-2xl font-light max-w-2xl mx-auto mb-10 leading-relaxed">
                No React. No Node.js. No complexity.<br>
                Just Java, clean templates, and stunning UI.
            </p>
            <div class="fade-up delay-4 flex flex-wrap gap-4 justify-center">
                <a href="/about" class="px-8 py-3.5 bg-emerald-500 hover:bg-emerald-400 text-zinc-950 font-semibold rounded-full transition-all duration-200 hover:scale-105">
                    Learn More
                </a>
                <a href="#features" class="px-8 py-3.5 border border-zinc-700 hover:border-zinc-500 text-zinc-300 font-semibold rounded-full transition-all duration-200">
                    See Features
                </a>
            </div>
        </div>
    </section>

    <!-- Features -->
    <section id="features" class="py-28 px-6">
        <div class="max-w-6xl mx-auto">
            <div class="text-center mb-16">
                <h2 class="font-display text-4xl md:text-5xl font-bold mb-4">Everything You Need</h2>
                <p class="text-zinc-400 text-lg">A focused stack. No bloat. No JavaScript fatigue.</p>
            </div>
            <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                <!-- Card 1 -->
                <div class="card-hover flex flex-col bg-zinc-900 border border-zinc-800 rounded-2xl p-8">
                    <div class="w-12 h-12 rounded-xl bg-emerald-500/10 flex items-center justify-center mb-6 text-2xl">🍃</div>
                    <h3 class="font-display text-xl font-bold mb-3">JTE Templates</h3>
                    <p class="text-zinc-400 leading-relaxed">Type-safe Java templates. Your model objects flow directly into HTML — no JSON, no drift, no surprises.</p>
                    <a href="https://jte.gg/" target="_blank" rel="noopener noreferrer"
                       class="mt-auto pt-6 inline-flex items-center gap-1 text-sm font-semibold text-emerald-400 hover:text-emerald-300 transition-colors">
                        jte.gg <span aria-hidden="true">↗</span><span class="sr-only">(opens in a new tab)</span>
                    </a>
                </div>
                <!-- Card 2 -->
                <div class="card-hover flex flex-col bg-zinc-900 border border-zinc-800 rounded-2xl p-8">
                    <div class="w-12 h-12 rounded-xl bg-cyan-500/10 flex items-center justify-center mb-6 text-2xl">🎨</div>
                    <h3 class="font-display text-xl font-bold mb-3">Tailwind CSS</h3>
                    <p class="text-zinc-400 leading-relaxed">Utility-first styling compiled to a tiny CSS file. Beautiful, responsive, consistent — with zero custom CSS needed.</p>
                    <a href="https://tailwindcss.com/" target="_blank" rel="noopener noreferrer"
                       class="mt-auto pt-6 inline-flex items-center gap-1 text-sm font-semibold text-cyan-400 hover:text-cyan-300 transition-colors">
                        tailwindcss.com <span aria-hidden="true">↗</span><span class="sr-only">(opens in a new tab)</span>
                    </a>
                </div>
                <!-- Card 3 -->
                <div class="card-hover flex flex-col bg-zinc-900 border border-zinc-800 rounded-2xl p-8">
                    <div class="w-12 h-12 rounded-xl bg-violet-500/10 flex items-center justify-center mb-6 text-2xl">⚡</div>
                    <h3 class="font-display text-xl font-bold mb-3">Spring Boot</h3>
                    <p class="text-zinc-400 leading-relaxed">Deploy as a single JAR. No Node server. No build pipeline. Just run and it works.</p>
                    <a href="https://spring.io/projects/spring-boot/" target="_blank" rel="noopener noreferrer"
                       class="mt-auto pt-6 inline-flex items-center gap-1 text-sm font-semibold text-violet-400 hover:text-violet-300 transition-colors">
                        spring.io <span aria-hidden="true">↗</span><span class="sr-only">(opens in a new tab)</span>
                    </a>
                </div>
                <!-- Card 4 -->
                <div class="card-hover flex flex-col bg-zinc-900 border border-zinc-800 rounded-2xl p-8">
                    <div class="w-12 h-12 rounded-xl bg-amber-500/10 flex items-center justify-center mb-6 text-2xl">🔒</div>
                    <h3 class="font-display text-xl font-bold mb-3">Spring Security</h3>
                    <p class="text-zinc-400 leading-relaxed">Sign-in, sessions and CSRF protection out of the box. Proven security instead of home-made code.</p>
                    <a href="https://spring.io/projects/spring-security/" target="_blank" rel="noopener noreferrer"
                       class="mt-auto pt-6 inline-flex items-center gap-1 text-sm font-semibold text-amber-400 hover:text-amber-300 transition-colors">
                        spring.io <span aria-hidden="true">↗</span><span class="sr-only">(opens in a new tab)</span>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- java -jar -->
    <section class="pb-28 px-6">
        <div class="max-w-5xl mx-auto grid md:grid-cols-2 gap-10 items-center">
            <div>
                <h2 class="font-display text-4xl md:text-5xl font-bold mb-5">
                    <code class="whitespace-nowrap text-emerald-400">java -jar</code> your UI.
                </h2>
                <p class="text-zinc-400 text-lg leading-relaxed mb-4">
                    Pages, styles, fonts and security all live in one file. No Node server, no separate frontend deployment, no asset pipeline.
                </p>
                <p class="text-zinc-400 leading-relaxed">
                    If it runs Java, it runs your UI: a laptop, a virtual machine, a container or AWS Lambda.
                </p>
            </div>
            <div class="bg-zinc-900 border border-zinc-800 rounded-2xl overflow-hidden shadow-2xl" role="img" aria-label="Terminal: build with Maven, then start the whole site with java -jar">
                <div class="flex gap-1.5 px-4 py-3 border-b border-zinc-800">
                    <span class="w-3 h-3 rounded-full bg-zinc-700"></span>
                    <span class="w-3 h-3 rounded-full bg-zinc-700"></span>
                    <span class="w-3 h-3 rounded-full bg-zinc-700"></span>
                </div>
                <pre class="p-4 sm:p-5 text-[11px] sm:text-sm leading-loose overflow-x-auto"><code><span class="text-zinc-500">$</span> ./mvnw package
<span class="text-zinc-500">$</span> java -jar target/jarloom-site.jar
<span class="text-emerald-400">Started Application in 3.1 seconds</span>
<span class="text-zinc-500">→</span> http://localhost:8080</code></pre>
            </div>
        </div>
    </section>

    <!-- Stats Banner -->
    <section class="py-16 px-6 border-y border-zinc-800 bg-zinc-900/40">
        <div class="max-w-4xl mx-auto grid grid-cols-3 gap-4 sm:gap-8 text-center">
            <div>
                <div class="font-display text-5xl font-extrabold text-emerald-400 mb-2">0</div>
                <div class="text-zinc-400 text-xs sm:text-sm uppercase tracking-normal sm:tracking-widest">npm packages</div>
            </div>
            <div>
                <div class="font-display text-5xl font-extrabold text-cyan-400 mb-2">1</div>
                <div class="text-zinc-400 text-xs sm:text-sm uppercase tracking-normal sm:tracking-widest">JAR to deploy</div>
            </div>
            <div>
                <div class="font-display text-5xl font-extrabold text-violet-400 mb-2">∞</div>
                <div class="text-zinc-400 text-xs sm:text-sm uppercase tracking-normal sm:tracking-widest">possibilities</div>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="py-28 px-6 text-center">
        <div class="max-w-2xl mx-auto">
            <h2 class="font-display text-4xl md:text-5xl font-bold mb-6">Ready to Build?</h2>
            <p class="text-zinc-400 text-lg mb-10">Start with Spring Boot, JTE, and Tailwind. Ship fast. Stay Java.</p>
            <a href="/about" class="inline-block px-10 py-4 bg-gradient-to-r from-emerald-500 to-cyan-500 text-zinc-950 font-bold rounded-full hover:scale-105 transition-transform duration-200">
                Get Started →
            </a>
        </div>
    </section>
`)
