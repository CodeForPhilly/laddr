{extends designs/site.tpl}

{block title}Project Updates &mdash; {$dwoo.parent}{/block}
{block content}
    <h2>
        Project Updates
        {if $Project}
            in <a href="{$Project->getURL()}">{$Project->Title|escape}</a>
        {/if}
    </h2>

    {foreach item=Update from=$data}
        {projectUpdate $Update headingLevel=h3 showProject=true}
    {/foreach}

{/block}