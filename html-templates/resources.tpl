{extends designs/site.tpl}

{block title}{_ Resources} &mdash; {$dwoo.parent}{/block}

{block content}
    <h2>{_ Resources}</h2>
    <ul>
        {include includes/site.resourcelinks.tpl}
    </ul>
{/block}