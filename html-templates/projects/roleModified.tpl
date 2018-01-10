{extends designs/site.tpl}

{block title}{_ "Roles"} &mdash; {$dwoo.parent}{/block}

{block content}
    {capture assign=project}{projectLink $Project}{/capture}

    <div class="page-header">
        <h1>Role Modified</h1>
    </div>
    <p class="lead">{sprintf(_("%s has been modified for %s"), $data->Role, $project)}</p>
{/block}