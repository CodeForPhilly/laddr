{extends designs/site.tpl}

{block title}Buzz Saved &mdash; {$dwoo.parent}{/block}

{block content}
    <p><a href="{$data->getURL()}">{$data->Headline|escape}</a> {tif $data->isNew ? posted : updated} for {projectLink $data->Project}</p>
{/block}