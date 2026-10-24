@import com.jarloom.security.CurrentUser
@import org.springframework.security.web.csrf.CsrfToken
@param CurrentUser currentUser
@param CsrfToken csrf
@param boolean error

@template.layout.page(
    title = "Sign in — Jarloom",
    page = "login",
    active = "secured",
    currentUser = currentUser,
    style = @`
    <style>
        .hero-glow {
            background: radial-gradient(ellipse 70% 40% at 50% 0%, rgba(52,211,153,0.12), transparent);
        }
    </style>
    `,
    content = @`
    <section class="hero-glow min-h-screen flex items-center justify-center px-6 pt-28 pb-20">
        <div class="w-full max-w-sm">
            <div class="text-center mb-8">
                <div class="inline-block mb-6 px-4 py-1.5 rounded-full border border-emerald-500/30 bg-emerald-500/10 text-emerald-400 text-xs font-semibold tracking-widest uppercase">
                    Spring Security demo
                </div>
                <h1 class="font-display text-4xl font-extrabold tracking-tight mb-3">Sign in</h1>
                <p class="text-zinc-400">Sign in to open the secured page.</p>
            </div>

            @if(error)
                <div class="mb-6 rounded-xl border border-rose-500/30 bg-rose-500/10 px-4 py-3 text-sm text-rose-300" role="alert">
                    Wrong username or password. Try demo / demo.
                </div>
            @endif

            <%-- OAuth2 login buttons: prepared, not enabled. Uncomment together with oauth2Login() in SecurityConfig.
            <div class="space-y-3 mb-6">
                <a href="/oauth2/authorization/github" class="flex items-center justify-center gap-2 w-full py-3 bg-white hover:bg-zinc-200 text-zinc-950 font-semibold rounded-full transition-colors">
                    Continue with GitHub
                </a>
                <a href="/oauth2/authorization/google" class="flex items-center justify-center gap-2 w-full py-3 border border-zinc-700 hover:border-zinc-500 text-zinc-200 font-semibold rounded-full transition-colors">
                    Continue with Google
                </a>
            </div>
            <div class="flex items-center gap-3 mb-6 text-xs text-zinc-500 uppercase tracking-widest">
                <span class="flex-1 border-t border-zinc-800"></span>or<span class="flex-1 border-t border-zinc-800"></span>
            </div>
            --%>

            <form method="post" action="/login" class="bg-zinc-900 border border-zinc-800 rounded-2xl p-6 space-y-5">
                <input type="hidden" name="${csrf.getParameterName()}" value="${csrf.getToken()}">
                <div>
                    <label for="username" class="block text-sm font-medium text-zinc-300 mb-2">Username</label>
                    <input id="username" name="username" type="text" autocomplete="username" required autofocus
                           class="w-full rounded-lg bg-zinc-950 border border-zinc-700 px-3 py-2.5 text-white placeholder-zinc-600 focus:outline-none focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500"
                           placeholder="demo">
                </div>
                <div>
                    <label for="password" class="block text-sm font-medium text-zinc-300 mb-2">Password</label>
                    <input id="password" name="password" type="password" autocomplete="current-password" required
                           class="w-full rounded-lg bg-zinc-950 border border-zinc-700 px-3 py-2.5 text-white placeholder-zinc-600 focus:outline-none focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500"
                           placeholder="demo">
                </div>
                <button type="submit" class="w-full py-3 bg-emerald-500 hover:bg-emerald-400 text-zinc-950 font-semibold rounded-full transition-colors">
                    Sign in
                </button>
            </form>

            <div class="mt-6 rounded-xl border border-dashed border-zinc-700 px-4 py-3 text-sm text-zinc-400">
                <div class="font-semibold text-zinc-300 mb-1">Public demo account</div>
                Username <code class="text-emerald-400">demo</code> · Password <code class="text-emerald-400">demo</code>
            </div>

            <div class="mt-4 rounded-xl border border-amber-500/30 bg-amber-500/5 px-4 py-3 text-sm text-zinc-400 leading-relaxed">
                <div class="font-semibold text-amber-400 mb-1">Why only a demo account?</div>
                Storing users and passwords yourself is hard to get right: password resets, lockouts, leaked passwords, two-factor login.
                Real applications should let a trusted provider handle sign-in with OAuth2, such as GitHub, Google or Keycloak.
                GitHub and Google login are prepared in the source code for a later version.
            </div>
        </div>
    </section>
`)
