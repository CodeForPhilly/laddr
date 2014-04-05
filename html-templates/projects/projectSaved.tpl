{extends designs/site.tpl}

{block title}Saved {$data->Title|escape} &mdash; Projects &mdash; {$dwoo.parent}{/block}

{block content}
    {$Project = $data}

    {if $Project->isNew}
        <p>Your project has been created: {projectLink $Project}</p>
    {else}
        <p>Your changes to {projectLink $Project} have been saved.</p>
    {/if}
{/block}