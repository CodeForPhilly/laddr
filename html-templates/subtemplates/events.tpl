{template eventLocation name address link=yes linkCls separator="<br>"}
    {if $link}
        <a class="{$linkCls|escape}" target="_blank" href="https://maps.google.com?q={implode(', ', array_filter(array($name, $address)))|escape:url}">
    {/if}

    {if $name && $address && ($name != $address)}
        {$name|escape}{$separator}{$address|escape}
    {else}
        {$name|default:$address|escape}
    {/if}

    {if $link}
        </a>
    {/if}
{/template}
