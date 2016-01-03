{extends designs/site.tpl}

{block title}{_ Resources} &mdash; {$dwoo.parent}{/block}

{block content}
    <header class="page-header">
        <h2>{_ Resources}</h2>
    </header>

    <ul>
        {include includes/site.resourcelinks.tpl}
    </ul>
{/block}