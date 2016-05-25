<!DOCTYPE html>
{load_templates designs/site.subtemplates.tpl}
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">

        {* now use {$dwoo.parent} on subpages to automatically fill in the site name *}
        <title>{block "title"}{Laddr::$siteName|escape}{/block}</title>

        {block "meta-info"}
            {include includes/site.meta-info.tpl}
        {/block}

        {block "meta-rendering"}
            {include includes/site.meta-rendering.tpl}
        {/block}

        {block "favicons"}
            {include includes/site.favicons.tpl}
        {/block}

        {block "css"}
            {include includes/site.css.tpl}
        {/block}

        {block "js-top"}
            {include includes/site.js-top.tpl}
        {/block}
    </head>

    {* using the responseID as a class on the body can help with subpage-specific styles *}
    <body class="{block 'body-class'}{str_replace('/', '_', $.responseId)}-tpl{/block}">
        {block header}
            <header class="site-header">
                {include includes/site.header.tpl}
            </header>
        {/block}

        {block content-wrapper}
            <main role="main">
                <div class="container">
                    {block content}{/block}
                </div>
            </main>
        {/block}

        {block footer-wrapper}
            <footer class="site-footer">
                {block footer}
                    {include includes/site.footer.tpl}
                {/block}
            </footer>
        {/block}

        {block "js-bottom"}
            {include includes/site.js-bottom.tpl}
        {/block}

        {block "js-analytics"}
            {include includes/site.analytics.tpl}
        {/block}

        {* enables site developers to dump the internal session log here by setting ?log_report=1 on any page *}
        {log_report}
    </body>
</html>