{extends designs/site.tpl}

{block title}Saved {$data->Title|escape} &mdash; Events &mdash; {$dwoo.parent}{/block}

{block content}
    {$Event = $data}

    {capture assign=eventLink}<a href="{$Event->getUrl()|escape}">{$Event->getTitle()|escape}</a>{/capture}

    <div class="page-header">
        <h1>Event Saved</h1>
    </div>
    {if $Event->isNew}
        <p>{_("Your event has been created: %s")|sprintf:$eventLink}</p>
    {else}
        <p>{_("Your changes to %s have been saved.")|sprintf:$eventLink}</p>
    {/if}
{/block}