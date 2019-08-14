{template eventLocation name address link=yes}
    {if $link}
        <a target="_blank" href="https://maps.google.com?q={implode(', ', array_filter(array($name, $address)))|escape:url}">
    {/if}

    {if $name && $address}
        {$name|escape} <br />
        @ {$address|escape}
    {else}
        {$name|default:$address|escape}
    {/if}
    
    {if $link}
        </a>
    {/if}
{/template}