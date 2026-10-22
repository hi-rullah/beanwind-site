@import com.javaview.security.CurrentUser
@param String active
@param CurrentUser currentUser

<!-- Navbar -->
<nav class="fixed top-0 w-full z-50 bg-zinc-950/80 backdrop-blur-md border-b border-zinc-800/60">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 py-4 flex justify-between items-center gap-4">
        <a href="/" class="font-display text-lg sm:text-xl font-bold">
            <span class="text-emerald-400">Java</span>View
        </a>
        <div class="flex gap-3 sm:gap-8 text-sm font-medium text-zinc-400">
            <a href="/" class="${"home".equals(active) ? "text-white" : "hover:text-white transition-colors"}">Home</a>
            <a href="/about" class="${"about".equals(active) ? "text-white" : "hover:text-white transition-colors"}">About</a>
            <a href="/secured" class="flex items-center gap-1.5 ${"secured".equals(active) ? "text-white" : "hover:text-white transition-colors"}">
                @if(currentUser.loggedIn())
                    <span class="w-2 h-2 rounded-full bg-emerald-400" title="Signed in as ${currentUser.name()}"></span>
                @endif
                Secured
            </a>
        </div>
    </div>
</nav>
