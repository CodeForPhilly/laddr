{load_templates subtemplates/personName.tpl}

{template avatar Person size=32 pixelRatio=2 urlOnly=false forceSquare=true imgCls=no}{strip}
    {$pixels = $size * $pixelRatio}

    {if $Person->PrimaryPhoto}
        {$src = $Person->PrimaryPhoto->getThumbnailRequest($pixels, $pixels, null, $forceSquare)}
    {else}
        {capture assign=src}//www.gravatar.com/avatar/{$Person->Email|strtolower|md5}?size={$pixels}&rating=g&default={Laddr::$gravatarDefault}{/capture}
    {/if}

    {if $urlOnly}
        {$src}
    {else}
        <img height={$size} alt="{personName $Person}" src="{$src}" class="avatar{if $imgCls} {$imgCls}{/if}">
    {/if}
{/strip}{/template}

{template personLink Person photo=no photoSize=64 pixelRatio=2 linkCls=no imgCls=no nameCls=no summary=yes}{strip}
    <a href="{$Person->getURL()}" title="{personName $Person}" {if $linkCls}class="{$linkCls}"{/if}>
        {if $photo}
            {$pixels = $photoSize}
            {if $pixelRatio}
                {$pixels = $photoSize * $pixelRatio}
            {/if}
            {if $Person->PrimaryPhoto}
                {$src = $Person->PrimaryPhoto->getThumbnailRequest($pixels, $pixels)}
            {else}
                {capture assign=src}//www.gravatar.com/avatar/{$Person->Email|strtolower|md5}?size={$pixels}&rating=g&default={Laddr::$gravatarDefault}{/capture}
            {/if}
            <img src="{$src}" class="avatar {if $imgCls}{$imgCls}{/if}" width="{$photoSize}" height="{$photoSize}" />
        {/if}
        <span class="name">{personName $Person summary=$summary}</span>
    </a>
{/strip}{/template}
