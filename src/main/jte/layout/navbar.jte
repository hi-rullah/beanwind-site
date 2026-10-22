@param String active

<!-- Navbar -->
<nav class="fixed top-0 w-full z-50 bg-zinc-950/80 backdrop-blur-md border-b border-zinc-800/60">
    <div class="max-w-6xl mx-auto px-6 py-4 flex justify-between items-center">
        <a href="/" class="font-display text-xl font-bold">
            <span class="text-emerald-400">Java</span>View
        </a>
        <div class="flex gap-8 text-sm font-medium text-zinc-400">
            <a href="/" class="${"home".equals(active) ? "text-white" : "hover:text-white transition-colors"}">Home</a>
            <a href="/about" class="${"about".equals(active) ? "text-white" : "hover:text-white transition-colors"}">About</a>
        </div>
    </div>
</nav>
