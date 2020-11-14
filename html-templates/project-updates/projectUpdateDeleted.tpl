{extends designs/site.tpl}

{block title}{_ 'Update Deleted'} &mdash; {$dwoo.parent}{/block}

{block content}
    {capture assign=projectUpdateLink}<a href="/projects/{$data->Project->Handle}/updates/{$data->Number}">{_("Update #%u")|sprintf:$data->Number}</a>{/capture}
    {capture assign=projectDataLink}{projectLink $data->Project}{/capture}
    <p>{sprintf(_("%s deleted for %s"), $projectUpdateLink, $projectDataLink)}</p>
{/block}
