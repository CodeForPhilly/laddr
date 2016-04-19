{extends designs/site.tpl}

{block title}{_ Resources} &mdash; {$dwoo.parent}{/block}

{block content}
    <div class="page-header">
        <h1>{_ Resources}</h1>
    </div>

    <ul>
        {include includes/site.resourcelinks.tpl}
    </ul>
{/block}