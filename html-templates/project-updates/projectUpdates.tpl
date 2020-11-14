{extends designs/site.tpl}

{block meta-info}
    {$dwoo.parent}
    <link rel="alternate" type="application/rss+xml" title="RSS" href="/project-updates?{if $Project}ProjectID={$Project->ID}&amp;{/if}format=rss">
{/block}

{block title}{_ 'Project Updates'} &mdash; {$dwoo.parent}{/block}
{block content}
    <header class="page-header">
        <h2>
          {capture assign=projectTitleLink}<a href="{$Project->getURL()}">{$Project->Title|escape}</a>{/capture}
          {if $Project}
            {sprintf(_("Project Updates in %s"), $projectTitleLink)}
          {else}
            {_ "Project Updates"}
          {/if}
        </h2>
    </header>

    {foreach item=Update from=$data}
        {projectUpdate $Update headingLevel=h3 showProject=true}
    {/foreach}

{/block}
