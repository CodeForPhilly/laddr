{extends designs/site.tpl}

{block title}{_ "Roles"} &mdash; {$dwoo.parent}{/block}

{block content}
    {capture assign=project}{projectLink $Project}{/capture}

    <div class="page-header">
        <h1>Application Added</h1>
    </div>
    <p class="lead">{sprintf(_(Your application for "%s has been added to %s"), $data->Role, $project)}</p>
{/block}