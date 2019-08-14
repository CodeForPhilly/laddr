<div class="site-branding">
    <a href="/">
        {if Site::resolvePath('site-root/img/logo.png')}
            <img class="site-logo" src="{versioned_url 'img/logo.png'}" height=80 alt="">
        {elseif Site::resolvePath('site-root/apple-touch-icon.png')}
            <img class="site-icon" src="{versioned_url '/apple-touch-icon.png'}" width=36 alt="">
        {/if}
        <div class="text">
            <big class="site-name">{$.Site.title|escape}</big>
        </div>
    </a>
</div>