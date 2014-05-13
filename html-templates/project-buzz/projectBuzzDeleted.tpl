{extends designs/site.tpl}

{block title}Buzz Deleted &mdash; {$dwoo.parent}{/block}

{block content}
    <p><a href="{$data->getURL()}">{$data->Headline|escape}</a> deleted for {projectLink $data->Project}</p>
{/block}