<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JavaView — Java-First UI Platform</title>
    <link rel="stylesheet" href="/css/output.css">
    <script src="/js/index.js" defer></script>
    <style>
        body { font-family: 'DM Sans', sans-serif; }
        .font-display { font-family: 'Syne', sans-serif; }
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
    <link rel="icon" type="image/png" href="/images/favicon/favicon-96x96.png" sizes="96x96" />
    <link rel="icon" type="image/svg+xml" href="/images/favicon/favicon.svg" />
    <link rel="shortcut icon" href="/images/favicon/favicon.ico" />
    <link rel="apple-touch-icon" sizes="180x180" href="/images/favicon/apple-touch-icon.png" />
    <link rel="manifest" href="/images/favicon/site.webmanifest" />
</head>
<body class="bg-zinc-950 text-white">

    @template.layout.navbar(active = "home")

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
            <div class="grid md:grid-cols-3 gap-6">
                <!-- Card 1 -->
                <div class="card-hover bg-zinc-900 border border-zinc-800 rounded-2xl p-8">
                    <div class="w-12 h-12 rounded-xl bg-emerald-500/10 flex items-center justify-center mb-6 text-2xl">🍃</div>
                    <h3 class="font-display text-xl font-bold mb-3">JTE Templates</h3>
                    <p class="text-zinc-400 leading-relaxed">Type-safe Java templates. Your model objects flow directly into HTML — no JSON, no drift, no surprises.</p>
                </div>
                <!-- Card 2 -->
                <div class="card-hover bg-zinc-900 border border-zinc-800 rounded-2xl p-8">
                    <div class="w-12 h-12 rounded-xl bg-cyan-500/10 flex items-center justify-center mb-6 text-2xl">🎨</div>
                    <h3 class="font-display text-xl font-bold mb-3">Tailwind CSS</h3>
                    <p class="text-zinc-400 leading-relaxed">Utility-first styling compiled to a tiny CSS file. Beautiful, responsive, consistent — with zero custom CSS needed.</p>
                </div>
                <!-- Card 3 -->
                <div class="card-hover bg-zinc-900 border border-zinc-800 rounded-2xl p-8">
                    <div class="w-12 h-12 rounded-xl bg-violet-500/10 flex items-center justify-center mb-6 text-2xl">⚡</div>
                    <h3 class="font-display text-xl font-bold mb-3">Spring Boot</h3>
                    <p class="text-zinc-400 leading-relaxed">Deploy as a single JAR. No Node server. No build pipeline. Just run and it works.</p>
                </div>
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

    @template.layout.footer()

</body>
</html>
