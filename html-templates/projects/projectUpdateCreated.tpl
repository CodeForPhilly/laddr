{extends designs/site.tpl}

{block title}{_ "Update Posted"} &mdash; {$dwoo.parent}{/block}

{block content}
    {capture assign=updateNumberText}<a href="/projects/{$data->Project->Handle}/updates/{$data->Number}">{_("Update #%u")|sprintf:$data->Number}</a>{/capture}
    {capture assign=projectNameLink}{projectLink $data->Project}{/capture}
    <p>{sprintf(_("%s posted to %s"), $updateNumberText, $projectNameLink)}</p>
{/block}
