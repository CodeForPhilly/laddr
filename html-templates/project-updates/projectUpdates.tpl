{extends designs/site.tpl}

{block meta-info}
    {$dwoo.parent}
    <link rel="alternate" type="application/rss+xml" title="RSS" href="/project-updates?{if $Project}ProjectID={$Project->ID}&amp;{/if}format=rss">
{/block}

{block title}Project Updates &mdash; {$dwoo.parent}{/block}
{block content}
    <header class="page-header">
        <h2>
            Project Updates
            {if $Project}
                in <a href="{$Project->getURL()}">{$Project->Title|escape}</a>
            {/if}
        </h2>
    </header>

    {foreach item=Update from=$data}
        {projectUpdate $Update headingLevel=h3 showProject=true}
    {/foreach}

{/block}