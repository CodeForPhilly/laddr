{extends designs/site.tpl}

{block title}{_ 'Update Saved'} &mdash; {$dwoo.parent}{/block}

{block content}
    {capture assign=updateNumberText}<a href="/projects/{$data->Project->Handle}/updates/{$data->Number}">{_("Update #%u")|sprintf:$data->Number}</a>{/capture}
    {capture assign=projectNameText}{projectLink $data->Project}{/capture}
    <p>{sprintf(_("%s updated for %s"), $updateNumberText, $projectNameText)}</p>
{/block}
