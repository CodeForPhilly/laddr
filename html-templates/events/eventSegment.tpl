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

    <div class="page-header">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/events">{_ "Events"}</a></li>
            <li class="breadcrumb-item"><a href="{$Event->getUrl()}">{$Event->Title|escape}</a></li>
            <li class="breadcrumb-item active">{_ "Schedule"}</li>
        </ol>
        <div class="btn-toolbar pull-right">
            {if $.User}
                <a class="btn btn-secondary" href="{$Segment->getUrl(edit)}">{icon "pencil"}&nbsp;{_ "Edit Segment"}</a>
            {/if}
        </div>
        <h1>{$Segment->Title|escape}</h1>
    </div>

    <div class="row">
        <dl class="event-segment-details col-md-4 order-md-last">
            <dt>{_ Starts}</dt>
                <dd class="d-flex my-2 align-items-baseline">
                    <div class="mr-2">{icon "clock-o" fa-fw}</div>
                    <div class="flex-fill">{timestamp $Segment->StartTime time='auto'}</div>
                </dd>

            {if $Segment->EndTime}
                <dt>{_ Ends}</dt>
                <dd class="d-flex my-2 align-items-baseline">
                    <div class="mr-2">{icon "clock-o" fa-fw}</div>
                    <div class="flex-fill">{timestamp $Segment->EndTime time='auto'}</div>
                </dd>
            {/if}

            {if $Segment->LocationName || $Segment->LocationAddress}
                <dt>{_ Location}</dt>
                <dd class="d-flex my-2 align-items-baseline">
                    <div class="text-danger mr-2">{icon "map-marker" fa-fw}</div>
                    <div class="flex-fill">{eventLocation name=$Segment->LocationName
                        address=$Segment->LocationAddress}
                    </div>
                </dd>
            {/if}
        </dl>

        <div class="col-md-8">
            {if $Segment->Description}
                <div
                    class="content-markdown event-segment-description content-editable"
                    {if $.User->hasAccountLevel('Staff')}
                        data-content-endpoint="{$Event->getUrl(segments)}"
                        data-content-id="{$Segment->Handle}"
                        data-content-field="Description"
                        data-content-value="{$Segment->Description|escape}"
                        data-content-renderer="markdown"
                    {/if}
                >
                    {$Segment->Description|escape|markdown}
                </div>
            {/if}
        </div>
    </div>
{/block}
