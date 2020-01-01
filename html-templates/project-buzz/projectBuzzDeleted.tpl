{extends designs/site.tpl}

{block title}{_ 'Buzz Deleted'} &mdash; {$dwoo.parent}{/block}

{block content}
    {capture assign=buzzDeletedLink}<a href="{$data->getURL()}">{$data->Headline|escape}</a>{/capture}
    {capture assign=projectName}{projectLink $data->Project}{/capture}
    <p>{sprintf(_("%s deleted for %s"), $buzzDeletedLink, $projectName)}</p>
{/block}
