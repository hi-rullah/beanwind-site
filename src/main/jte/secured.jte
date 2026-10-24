@import java.util.List
@import com.beanwind.security.CurrentUser
@import org.springframework.security.web.csrf.CsrfToken
@param CurrentUser currentUser
@param CsrfToken csrf
@param List<String> authorities

@template.layout.page(
    title = "Secured — Beanwind",
    page = "secured",
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
    <section class="hero-glow pt-36 pb-20 px-6">
        <div class="max-w-3xl mx-auto">
            <div class="text-center mb-12">
                <div class="inline-block mb-6 px-4 py-1.5 rounded-full border border-emerald-500/30 bg-emerald-500/10 text-emerald-400 text-xs font-semibold tracking-widest uppercase">
                    🔒 Secured page
                </div>
                <h1 class="font-display text-[10vw] sm:text-5xl font-extrabold tracking-tight break-words mb-4">Welcome, ${currentUser.name()}</h1>
                <p class="text-zinc-400 text-lg leading-relaxed">
                    You can see this page because you are signed in. Visitors who are not signed in are sent to the login page first.
                </p>
            </div>

            <!-- Who you are -->
            <div class="bg-zinc-900 border border-zinc-800 rounded-2xl p-6 mb-10">
                <dl class="grid sm:grid-cols-3 gap-6 text-sm">
                    <div>
                        <dt class="text-zinc-500 mb-1">Signed in as</dt>
                        <dd class="font-semibold">${currentUser.name()}</dd>
                    </div>
                    <div>
                        <dt class="text-zinc-500 mb-1">Authorities</dt>
                        <dd class="font-semibold">
                            @for(String authority : authorities)
                                <span class="inline-block mr-1 px-2 py-0.5 rounded-full bg-emerald-500/10 text-emerald-400 text-xs">${authority}</span>
                            @endfor
                            <span class="block mt-2 text-zinc-500 text-xs font-normal">ROLE_ = what you may do. FACTOR_ = how you proved who you are.</span>
                        </dd>
                    </div>
                    <div>
                        <dt class="text-zinc-500 mb-1">Login method</dt>
                        <dd class="font-semibold">Username and password</dd>
                    </div>
                </dl>
            </div>

            <!-- What Spring Security does -->
            <h2 class="font-display text-2xl font-bold mb-6">What Spring Security did for you</h2>
            <ol class="space-y-4 mb-12">
                <li class="flex gap-4">
                    <span class="font-display text-emerald-400 font-bold shrink-0">01</span>
                    <p class="text-zinc-400 leading-relaxed"><span class="text-zinc-200 font-medium">Checked the request.</span> Every request passes a filter chain. <code class="text-zinc-300">/secured</code> requires login, so you were sent to <code class="text-zinc-300">/login</code> first.</p>
                </li>
                <li class="flex gap-4">
                    <span class="font-display text-emerald-400 font-bold shrink-0">02</span>
                    <p class="text-zinc-400 leading-relaxed"><span class="text-zinc-200 font-medium">Verified the password.</span> Passwords are stored only as BCrypt hashes, never as plain text.</p>
                </li>
                <li class="flex gap-4">
                    <span class="font-display text-emerald-400 font-bold shrink-0">03</span>
                    <p class="text-zinc-400 leading-relaxed"><span class="text-zinc-200 font-medium">Remembered you.</span> A signed cookie keeps you signed in. The signature means it cannot be edited or forged, and any server instance can check it, so no server memory is needed.</p>
                </li>
                <li class="flex gap-4">
                    <span class="font-display text-emerald-400 font-bold shrink-0">04</span>
                    <p class="text-zinc-400 leading-relaxed"><span class="text-zinc-200 font-medium">Protected the forms.</span> The login form and the sign-out button carry a CSRF token, so other sites cannot submit them on your behalf.</p>
                </li>
            </ol>

            <form method="post" action="/logout" class="text-center">
                <input type="hidden" name="${csrf.getParameterName()}" value="${csrf.getToken()}">
                <button type="submit" class="px-8 py-3 border border-zinc-700 hover:border-zinc-500 text-zinc-300 font-semibold rounded-full transition-colors">
                    Sign out
                </button>
            </form>

        </div>
    </section>
`)
