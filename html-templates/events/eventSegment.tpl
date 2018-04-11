{extends "designs/site.tpl"}

{block title}{$data->Title|escape} @ {$data->Event->Title|escape} &mdash; {$dwoo.parent}{/block}

{block css}
    {$dwoo.parent}

    <style>
        .event-segment-description p:last-child {
            margin-bottom: 0;
        }

        .event-segment-details dt {
            font-size: 130%;
        }
        .event-segment-details dd {
            margin-bottom: 1em;
        }
    </style>
{/block}

{block content}
    {$Segment = $data}
    {$Event = $Segment->Event}
    {load_templates "subtemplates.tpl"}

    <div class="page-header">
        <ol class="breadcrumb">
            <li><a href="/events">{_ "Events"}</a></li>
            <li><a href="{$Event->getUrl()}">{$Event->Title|escape}</a></li>
            <li>Schedule</li>
        </ol>
        <div class="btn-toolbar pull-right">
            {if $.User}
                <a class="btn btn-success" href="{$Segment->getUrl(edit)}">{glyph "pencil"}&nbsp;{_ "Edit Segment"}</a>
            {/if}
        </div>
        <h1>{$Segment->Title|escape}</h1>
    </div>

    <div class="row">
        <div class="col-md-9">
            {if $Segment->Description}
                <div class="content-markdown event-segment-description well">{$Segment->Description|escape|markdown}</div>
            {/if}
        </div>
        
        <dl class="event-segment-details col-md-3">
            <dt>Starts</dt>
            <dd>{timestamp $Segment->StartTime time='auto'}</dd>

            {if $Segment->EndTime}
                <dt>Ends</dt>
                <dd>{timestamp $Segment->EndTime time='auto'}</dd>
            {/if}

            {if $Segment->LocationName || $Segment->LocationAddress}
                <dt>Location</dt>
                <dd>{eventLocation name=$Segment->LocationName address=$Segment->LocationAddress}</dd>
            {/if}
        </dl>
    </div>
{/block}