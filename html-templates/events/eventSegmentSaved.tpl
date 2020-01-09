{extends designs/site.tpl}

{block title}Saved {$data->Title|escape} &mdash; {$dwoo.parent}{/block}

{block content}
    {$Segment = $data}

    {capture assign=linkHtml}<a href="{$Segment->getUrl()|escape}">{$Segment->getTitle()|escape}</a>{/capture}

    <div class="page-header">
        <h1>{_ "Event Segment Saved"}</h1>
    </div>

    {if $Segment->isNew}
        <p>{_("Your event has been created: %s")|sprintf:$linkHtml}</p>
    {else}
        <p>{_("Your changes to %s have been saved.")|sprintf:$linkHtml}</p>
    {/if}
{/block}
