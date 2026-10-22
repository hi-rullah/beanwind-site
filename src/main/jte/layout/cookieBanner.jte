<%-- Cookie banner: hidden until js/layout/consent.js finds no saved choice. Without JavaScript nothing is accepted. --%>
<div id="cookie-banner" hidden role="dialog" aria-labelledby="cookie-banner-title"
     class="fixed bottom-4 inset-x-4 z-50 mx-auto max-w-xl rounded-2xl border border-zinc-700 bg-zinc-900/95 backdrop-blur-md p-5 shadow-2xl">
    <div id="cookie-banner-title" class="font-display font-bold mb-2">Cookies</div>
    <p class="text-sm text-zinc-400 leading-relaxed mb-4">
        With your permission we set one cookie with an anonymous ID to count returning visitors.
        Cookies needed for sign-in are always used. No ads, no third parties.
        <a href="/privacy" class="text-emerald-400 hover:text-emerald-300 underline underline-offset-2">Privacy &amp; cookies</a>
    </p>
    <div class="grid grid-cols-2 gap-3">
        <button type="button" data-consent="rejected"
                class="py-2.5 border border-zinc-600 hover:border-zinc-400 text-zinc-200 text-sm font-semibold rounded-full transition-colors">
            Reject
        </button>
        <button type="button" data-consent="accepted"
                class="py-2.5 border border-zinc-600 hover:border-zinc-400 text-zinc-200 text-sm font-semibold rounded-full transition-colors">
            Accept
        </button>
    </div>
</div>
