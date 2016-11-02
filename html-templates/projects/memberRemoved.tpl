{extends designs/site.tpl}

{block title}Members &mdash; {$dwoo.parent}{/block}

{block content}
<div class="row">
    <div class="col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">
        <div class="page-header">
            <h1>Member Removed</h1>
        </div>
        <p>{personLink $Member} {if $data && $data->Role}({$data->Role|escape}){/if} has been removed from {projectLink $Project}</p>
    </div>
</div>
{/block}