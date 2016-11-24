{extends designs/site.tpl}

{block title}{_ 'Saved'} {$data->Title|escape} &mdash; {_ 'Projects'} &mdash; {$dwoo.parent}{/block}

{block content}
    {$Project = $data}

    {capture assign=projectLink}{projectLink $Project}{/capture}

    <div class="page-header">
        <h1>Project Created</h1>
    </div>
    {if $Project->isNew}
        <p>{_("Your project has been created: %s")|sprintf:$projectLink}</p>
    {else}
        <p>{_("Your changes to %s have been saved.")|sprintf:$projectLink}</p>
    {/if}
{/block}
