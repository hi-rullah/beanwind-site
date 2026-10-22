@import com.javaview.security.CurrentUser
@param CurrentUser currentUser

@template.layout.page(
    title = "Privacy & cookies — JavaView",
    page = "privacy",
    active = "privacy",
    currentUser = currentUser,
    content = @`
    <section class="pt-36 pb-20 px-6">
        <div class="max-w-3xl mx-auto">
            <div class="inline-block mb-6 px-4 py-1.5 rounded-full border border-emerald-500/30 bg-emerald-500/10 text-emerald-400 text-xs font-semibold tracking-widest uppercase">
                Privacy
            </div>
            <h1 class="font-display text-[10vw] sm:text-5xl font-extrabold tracking-tight mb-6">Privacy &amp; cookies</h1>
            <p class="text-zinc-400 text-lg leading-relaxed mb-14">
                JavaView is a demo site. This page explains what we record when you visit, which cookies we use and how you can choose.
            </p>

            <h2 class="font-display text-2xl font-bold mb-4">What we log on each page view</h2>
            <p class="text-zinc-400 leading-relaxed mb-4">
                When you open a page, our server writes one line to its log. We use it to count visits, find errors and keep the site secure. This needs no cookie.
            </p>
            <ul class="list-disc pl-6 space-y-1 text-zinc-400 mb-4">
                <li>the page address, the time and whether the page loaded correctly</li>
                <li>your IP address with the last part removed, so it points to a network, not to you</li>
                <li>your browser type (user agent) and the page you came from (referrer)</li>
                <li>your username, if you are signed in</li>
                <li>an anonymous visitor ID, only if you accepted the analytics cookie</li>
            </ul>
            <p class="text-zinc-400 leading-relaxed mb-14">
                The logs are stored with our hosting provider (Amazon Web Services, EU region) for at most 30 days and then deleted.
            </p>

            <h2 id="cookies" class="font-display text-2xl font-bold mb-4 scroll-mt-28">Cookies</h2>
            <div class="grid md:grid-cols-3 gap-4 mb-6">
                <div class="bg-zinc-900 border border-zinc-800 rounded-xl p-4">
                    <div class="flex items-center justify-between gap-3 mb-2">
                        <code class="text-zinc-200 text-sm">JSESSIONID</code>
                        <span class="text-xs px-2 py-0.5 rounded-full bg-zinc-800 text-zinc-300">Necessary</span>
                    </div>
                    <p class="text-zinc-400 text-sm leading-relaxed">Keeps you signed in and protects forms. Set when you open the sign-in page.</p>
                    <p class="text-zinc-500 text-xs mt-2">Duration: until you sign out or close the browser</p>
                </div>
                <div class="bg-zinc-900 border border-zinc-800 rounded-xl p-4">
                    <div class="flex items-center justify-between gap-3 mb-2">
                        <code class="text-zinc-200 text-sm">jv_consent</code>
                        <span class="text-xs px-2 py-0.5 rounded-full bg-zinc-800 text-zinc-300">Necessary</span>
                    </div>
                    <p class="text-zinc-400 text-sm leading-relaxed">Remembers your cookie choice.</p>
                    <p class="text-zinc-500 text-xs mt-2">Duration: 6 months</p>
                </div>
                <div class="bg-zinc-900 border border-zinc-800 rounded-xl p-4">
                    <div class="flex items-center justify-between gap-3 mb-2">
                        <code class="text-zinc-200 text-sm">jv_visitor</code>
                        <span class="text-xs px-2 py-0.5 rounded-full bg-emerald-500/10 text-emerald-400">Analytics</span>
                    </div>
                    <p class="text-zinc-400 text-sm leading-relaxed">A random, anonymous ID to count returning visitors. Only set if you accept.</p>
                    <p class="text-zinc-500 text-xs mt-2">Duration: 6 months</p>
                </div>
            </div>
            <p class="text-zinc-400 leading-relaxed mb-6">
                If you reject, no analytics cookie is set, and an existing one is deleted on your next page view.
            </p>
            <a href="#cookies" data-cookie-settings
               class="inline-block mb-14 px-6 py-2.5 border border-zinc-700 hover:border-zinc-500 text-zinc-200 text-sm font-semibold rounded-full transition-colors">
                Change cookie settings
            </a>

            <h2 class="font-display text-2xl font-bold mb-4">What we do not do</h2>
            <ul class="list-disc pl-6 space-y-1 text-zinc-400">
                <li>no advertising and no third-party trackers or analytics services</li>
                <li>fonts are served by this site, so your browser does not contact Google Fonts</li>
                <li>we do not sell or share the data</li>
            </ul>
        </div>
    </section>
`)
