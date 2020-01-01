{extends designs/site.tpl}

{block title}{_ 'Buzz Saved'} &mdash; {$dwoo.parent}{/block}

{block content}
    {capture assign=buzzHeadlineLink}<a href="{$data->getURL()}">{$data->Headline|escape}</a> {tif $data->isNew ? {_ posted} : {_ updated}}{/capture}
    {capture assign=projectNameLink}{projectLink $data->Project}{/capture}
    <p>{sprintf(_("%s for %s"), $buzzHeadlineLink, $projectNameLink)}</p>
{/block}
