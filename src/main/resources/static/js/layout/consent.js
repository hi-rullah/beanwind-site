// Cookie banner, loaded by layout/page.jte on every page (scripts in js/layout/ belong to the layout templates).
// Saves the visitor's choice in the jv_consent cookie. The server sets the jv_visitor analytics cookie only after
// "accepted" and deletes it after "rejected" (see VisitorTrackingInterceptor).
(() => {
    const banner = document.getElementById('cookie-banner');
    if (!banner) {
        return;
    }
    const sixMonths = 60 * 60 * 24 * 180;
    const hasChoice = document.cookie.split('; ').some(cookie => cookie.startsWith('jv_consent='));

    if (!hasChoice) {
        banner.hidden = false;
    }

    banner.querySelectorAll('[data-consent]').forEach(button => {
        button.addEventListener('click', () => {
            const secure = location.protocol === 'https:' ? '; Secure' : '';
            document.cookie = `jv_consent=${button.dataset.consent}; Max-Age=${sixMonths}; Path=/; SameSite=Lax${secure}`;
            banner.hidden = true;
        });
    });

    // "Cookie settings" links (footer, privacy page) reopen the banner to change the choice
    document.querySelectorAll('[data-cookie-settings]').forEach(link => {
        link.addEventListener('click', event => {
            event.preventDefault();
            banner.hidden = false;
        });
    });
})();
