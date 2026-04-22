<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About — JavaView</title>
    <link rel="stylesheet" href="/css/output.css">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:ital,wght@0,300;0,400;0,500;1,300&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'DM Sans', sans-serif; }
        .font-display { font-family: 'Syne', sans-serif; }
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
    </style>
    <link rel="icon" type="image/png" href="/images/favicon/favicon-96x96.png" sizes="96x96" />
    <link rel="icon" type="image/svg+xml" href="/images/favicon/favicon.svg" />
    <link rel="shortcut icon" href="/images/favicon/favicon.ico" />
    <link rel="apple-touch-icon" sizes="180x180" href="/images/favicon/apple-touch-icon.png" />
    <link rel="manifest" href="/images/favicon/site.webmanifest" />
</head>
<body class="bg-zinc-950 text-white">

    <!-- Navbar -->
    <nav class="fixed top-0 w-full z-50 bg-zinc-950/80 backdrop-blur-md border-b border-zinc-800/60">
        <div class="max-w-6xl mx-auto px-6 py-4 flex justify-between items-center">
            <a href="/" class="font-display text-xl font-bold">
                <span class="text-emerald-400">Java</span>View
            </a>
            <div class="flex gap-8 text-sm font-medium text-zinc-400">
                <a href="/" class="hover:text-white transition-colors">Home</a>
                <a href="/about" class="text-white">About</a>
            </div>
        </div>
    </nav>

    <!-- Hero -->
    <section class="hero-glow pt-40 pb-20 px-6 text-center">
        <div class="max-w-3xl mx-auto">
            <div class="fade-up delay-1 inline-block mb-6 px-4 py-1.5 rounded-full border border-amber-500/30 bg-amber-500/10 text-amber-400 text-xs font-semibold tracking-widest uppercase">
                Our Story
            </div>
            <h1 class="fade-up delay-2 font-display text-6xl md:text-7xl font-extrabold leading-none mb-6 tracking-tight">
                Why <span class="gradient-text">JavaView</span>
            </h1>
            <p class="fade-up delay-3 text-zinc-400 text-xl font-light leading-relaxed">
                We believe Java teams shouldn't have to learn an entirely different ecosystem just to build a great UI. JavaView brings modern web design to the JVM — no compromise.
            </p>
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

    <!-- Tech Stack -->
    <section class="py-20 px-6 bg-zinc-900/40 border-y border-zinc-800">
        <div class="max-w-4xl mx-auto">
            <h2 class="font-display text-3xl font-bold text-center mb-12">The Stack</h2>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div class="bg-zinc-900 border border-zinc-800 rounded-xl p-6 text-center">
                    <div class="text-3xl mb-3">🍃</div>
                    <div class="font-display font-bold mb-1">Spring Boot</div>
                    <div class="text-zinc-500 text-xs">Foundation</div>
                </div>
                <div class="bg-zinc-900 border border-zinc-800 rounded-xl p-6 text-center">
                    <div class="text-3xl mb-3">📄</div>
                    <div class="font-display font-bold mb-1">JTE</div>
                    <div class="text-zinc-500 text-xs">Templates</div>
                </div>
                <div class="bg-zinc-900 border border-zinc-800 rounded-xl p-6 text-center">
                    <div class="text-3xl mb-3">🎨</div>
                    <div class="font-display font-bold mb-1">Tailwind</div>
                    <div class="text-zinc-500 text-xs">Styling</div>
                </div>
                <div class="bg-zinc-900 border border-zinc-800 rounded-xl p-6 text-center">
                    <div class="text-3xl mb-3">⚡</div>
                    <div class="font-display font-bold mb-1">Vanilla JS</div>
                    <div class="text-zinc-500 text-xs">Interactivity</div>
                </div>
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

    <!-- Footer -->
    <footer class="border-t border-zinc-800 py-10 text-center text-zinc-500 text-sm">
        <p>© 2026 JavaView. Built with Spring Boot + JTE + Tailwind.</p>
    </footer>

</body>
</html>
