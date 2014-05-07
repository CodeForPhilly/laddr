{extends designs/site.tpl}

{block title}Resources &mdash; {$dwoo.parent}{/block}

{block content}
    <h2>Resources</h2>
    <ul>
        {include includes/site.resourcelinks.tpl}
    </ul>
{/block}