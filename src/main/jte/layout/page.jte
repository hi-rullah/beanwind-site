@import com.beanwind.page.Assets
@import com.beanwind.security.CurrentUser
@import gg.jte.Content
@param String title
@param String page
@param String active
@param CurrentUser currentUser
@param Content content
@param Content style = null
@param String description = null
@param String canonicalUrl = null
@param boolean noindex = false
@param String ogImage = "/images/og/beanwind.png"

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="color-scheme" content="dark">
    <title>${title}</title>
    @if(description != null)
        <meta name="description" content="${description}">
    @endif
    @if(noindex)
        <%-- Sign-in, member and error pages: crawlers may fetch them but keep them out of search results --%>
        <meta name="robots" content="noindex">
    @endif
    @if(canonicalUrl != null)
        <%-- The one address search engines should index, even when the page is also reachable at another host --%>
        <link rel="canonical" href="${canonicalUrl}">
        <%-- Link previews when the page is shared (LinkedIn, Slack, WhatsApp, X, ...) --%>
        <meta property="og:type" content="website">
        <meta property="og:site_name" content="Beanwind">
        <meta property="og:title" content="${title}">
        <meta property="og:url" content="${canonicalUrl}">
        @if(description != null)
            <meta property="og:description" content="${description}">
        @endif
        <%-- The preview image must be an absolute URL: resolved against the canonical URL (site.base-url) --%>
        <meta property="og:image" content="${java.net.URI.create(canonicalUrl).resolve(ogImage).toString()}">
        <meta property="og:image:width" content="1200">
        <meta property="og:image:height" content="630">
        <meta property="og:image:alt" content="Beanwind: Build Beautiful Java Web Apps. One JAR. Whole UI.">
        <meta name="twitter:card" content="summary_large_image">
    @endif
    <%-- Fonts used above the fold: start downloading before the CSS is parsed, so text does not swap fonts --%>
    <link rel="preload" href="/fonts/syne-latin.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="/fonts/dm-sans-latin.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="stylesheet" href="${Assets.url("/css/output.css")}">
    <script src="${Assets.url("/js/layout/consent.js")}" defer></script>
    <script src="${Assets.url("/js/" + page + ".js")}" defer></script>
    <style>
        /* Dark background before output.css is applied: no white flash between pages */
        html { background-color: #09090b; }
        /* Cross-document view transitions: the browser crossfades between pages; the navbar stays in place */
        @view-transition { navigation: auto; }
        nav { view-transition-name: site-nav; }
    </style>
    @if(style != null)
        ${style}
    @endif
    <link rel="icon" type="image/png" href="/images/favicon/favicon-96x96.png" sizes="96x96" />
    <link rel="icon" type="image/svg+xml" href="/images/favicon/favicon.svg" />
    <link rel="shortcut icon" href="/images/favicon/favicon.ico" />
    <link rel="apple-touch-icon" sizes="180x180" href="/images/favicon/apple-touch-icon.png" />
    <link rel="manifest" href="/images/favicon/site.webmanifest" />
</head>
<body class="bg-zinc-950 text-white">

    @template.layout.navbar(active = active, currentUser = currentUser)

    ${content}

    @template.layout.footer()

    @template.layout.cookieBanner()

</body>
</html>
