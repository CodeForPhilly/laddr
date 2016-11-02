{extends designs/site.tpl}

{block title}{_ Resources} &mdash; {$dwoo.parent}{/block}

{block content}
<div class="row">
    <div class="col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2">
        <div class="page-header">
            <h1>{_ Resources}</h1>
        </div>

        <ul>
            {include includes/site.resourcelinks.tpl}
        </ul>
    </div>
</div>
{/block}