{extends designs/site.tpl}

{block title}{_ 'Members'} &mdash; {$dwoo.parent}{/block}

{block content}
    <div class="page-header">
        <h1>{_ "Maintainer Changed"}</h1>
    </div>
    {capture assign=maintainerNameLink}{personLink $data->Maintainer}{/capture}
    {capture assign=projectNameLink}{projectLink $data}{/capture}
    <p class="lead">{sprintf(_("%s has been made the maintainer of %s"), $maintainerNameLink, $projectNameLink)}</p>
{/block}
