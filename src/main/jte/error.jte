@import com.beanwind.security.CurrentUser
@param CurrentUser currentUser
@param Integer status
@param String error

<%-- Rendered by Spring Boot's /error controller for every error (404, 403, 500, ...).
     Its model has status, error (reason phrase), path and timestamp; the stack trace and message are never shown. --%>
!{int code = status == null ? 500 : status;}
!{String heading = switch (code) {
    case 403 -> "Access denied";
    case 404 -> "Page not found";
    case 405 -> "Not allowed";
    case 500 -> "Something went wrong";
    default -> error != null ? error : "Something went wrong";
};}

@template.layout.page(
    title = heading + " — Beanwind",
    page = "error",
    active = "",
    currentUser = currentUser,
    noindex = true,
    style = @`
    <style>
        .hero-glow {
            background: radial-gradient(ellipse 70% 40% at 50% 0%, rgba(244,63,94,0.10), transparent);
        }
    </style>
    `,
    content = @`
    <section class="hero-glow min-h-screen flex items-center justify-center px-6 pt-28 pb-20">
        <div class="w-full max-w-lg text-center">
            <div class="inline-block mb-6 px-4 py-1.5 rounded-full border border-rose-500/30 bg-rose-500/10 text-rose-300 text-xs font-semibold tracking-widest uppercase">
                Error ${code}
            </div>
            <h1 class="font-display text-[12vw] sm:text-6xl font-extrabold tracking-tight mb-4">${heading}</h1>
            <p class="text-zinc-400 text-lg leading-relaxed mb-10">
                @if(code == 404)
                    The page you are looking for does not exist or has been moved.
                @elseif(code == 403)
                    The request was refused. If you were signing in, the form may have expired: open the sign-in page again and retry.
                @elseif(code >= 500)
                    An unexpected error happened on our side. Please try again in a moment.
                @else
                    The request could not be completed.
                @endif
            </p>
            <div class="flex flex-wrap justify-center gap-3">
                <a href="/" class="px-8 py-3 bg-emerald-500 hover:bg-emerald-400 text-zinc-950 font-semibold rounded-full transition-colors">
                    Back to home
                </a>
                @if(code == 403)
                    <a href="/login" class="px-8 py-3 border border-zinc-700 hover:border-zinc-500 text-zinc-300 font-semibold rounded-full transition-colors">
                        Sign in
                    </a>
                @endif
            </div>
        </div>
    </section>
`)
