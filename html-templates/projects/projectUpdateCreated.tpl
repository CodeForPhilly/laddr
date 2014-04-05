{extends designs/site.tpl}

{block title}Update Posted &mdash; {$dwoo.parent}{/block}

{block content}
    <p><a href="/projects/{$data->Project->Handle}/updates/{$data->Number}">Update #{$data->Number}</a> posted to {projectLink $data->Project}</p>
{/block}