{extends designs/site.tpl}

{block title}{_ "Update Posted"} &mdash; {$dwoo.parent}{/block}

{block content}
    <p><a href="/projects/{$data->Project->Handle}/updates/{$data->Number}">{_("Update #%u")|sprintf:$data->Number}</a> {_ "posted to"} {projectLink $data->Project}</p>
{/block}