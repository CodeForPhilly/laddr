{load_templates subtemplates/personName.tpl}

{template avatar Person size=32 pixelRatio=2 urlOnly=false forceSquare=true imgCls=no}{strip}
    {$pixels = $size * $pixelRatio}

    {if $Person->PrimaryPhoto}
        {$src = $Person->PrimaryPhoto->getThumbnailRequest($pixels, $pixels, null, $forceSquare)}
    {else}
        {$src = cat("//www.gravatar.com/avatar/", md5(strtolower($Person->Email)), "?s=", $pixels, "&r=g&d=mm")}
    {/if}

    {if $urlOnly}
        {$src}
    {else}
        <img height={$size} alt="{personName $Person}" src="{$src}" class="avatar{if $imgCls} {$imgCls}{/if}">
    {/if}
{/strip}{/template}

{template personLink Person photo=no photoSize=64 pixelRatio=2 linkCls=no imgCls=no nameCls=no}{strip}
    <a href="{$Person->getURL()}" title="{personName $Person}" {if $linkCls}class="{$linkCls}"{/if}>
        {if $photo}
            {$pixels = $photoSize}
            {if $pixelRatio}
                {$pixels = $photoSize * $pixelRatio}
            {/if}
            {if $Person->PrimaryPhoto}
                {$src = $Person->PrimaryPhoto->getThumbnailRequest($pixels, $pixels)}
            {else}
                {$src = cat("//www.gravatar.com/avatar/", md5(strtolower($Person->Email)), "?s=", $pixels, "&r=g&d=mm")}
            {/if}
            <img src="{$src}" class="avatar {if $imgCls}{$imgCls}{/if}" width="{$photoSize}" height="{$photoSize}" />
        {/if}
        <span class="name {$imgCls}">{personName $Person}</span>
    </a>
{/strip}{/template}