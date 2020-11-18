{extends designs/site.tpl}

{block title}{_ "How to Help"} &mdash; {$dwoo.parent}{/block}

{block content}
<div class="row">
    <div class="col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2">
        <div class="page-header">
            <h1>{_ "How to Help"}</h1>
        </div>

        {capture assign=createProjectTextLink}<a href="/projects/create" class="btn btn-primary margin-right">{_ "Create a project"}</a>{/capture}
        {capture assign=findProjectTextLink}<a href="/projects">{_ "find an existing"}</a>{/capture}
        <p>{sprintf(_("%s or %s one to get involved with in our projects directory."), $createProjectTextLink, $findProjectTextLink)}</p>
    </div>
</div>
{/block}
