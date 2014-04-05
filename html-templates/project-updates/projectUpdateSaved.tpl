{extends designs/site.tpl}

{block title}Update Saved &mdash; {$dwoo.parent}{/block}

{block content}
    <p><a href="/projects/{$data->Project->Handle}/updates/{$data->Number}">Update #{$data->Number}</a> updated for {projectLink $data->Project}</p>
{/block}