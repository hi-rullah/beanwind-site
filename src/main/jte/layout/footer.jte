@import java.time.Year

<!-- Footer -->
<footer class="border-t border-zinc-800 py-10 text-center text-zinc-500 text-sm">
    <p class="font-display font-bold text-zinc-300 mb-2">One JAR. Whole UI.</p>
    <p>© ${Year.now().getValue()} Jarloom. Built with Spring Boot + JTE + Tailwind.</p>
    <p class="mt-3 flex justify-center gap-4">
        <a href="/privacy" class="hover:text-zinc-300 transition-colors">Privacy &amp; cookies</a>
        <a href="/privacy#cookies" data-cookie-settings class="hover:text-zinc-300 transition-colors">Cookie settings</a>
    </p>
</footer>
