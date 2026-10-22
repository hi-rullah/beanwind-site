@import com.javaview.security.CurrentUser
@import gg.jte.Content
@param String title
@param String page
@param String active
@param CurrentUser currentUser
@param Content content
@param Content style = null

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="color-scheme" content="dark">
    <title>${title}</title>
    <%-- Fonts used above the fold: start downloading before the CSS is parsed, so text does not swap fonts --%>
    <link rel="preload" href="/fonts/syne-latin.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="/fonts/dm-sans-latin.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="stylesheet" href="/css/output.css">
    <script src="/js/${page}.js" defer></script>
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

</body>
</html>
