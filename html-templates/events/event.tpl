{extends "designs/site.tpl"}

{block title}{$data->Title|escape} &mdash; {$dwoo.parent}{/block}

{block css}
    {$dwoo.parent}

    <style>
        .event-description p:last-child {
            margin-bottom: 0;
        }

        .event-details dt {
            font-size: 130%;
        }
        .event-details dd {
            margin-bottom: 1em;
        }

        .event-segments h4 {
            margin-top: 0;
        }
        .event-segments dl {
            margin-bottom: 0;
        }
        .event-segments dd {
            margin-bottom: 0.5em;
        }
        .event-segments .event-location {
            display: block;
            margin-top: 1em;
            margin-bottom: 1em;
        }
        .event-segments .event-location dt {
            font-size: 200%;
        }
    </style>
{/block}

{block content}
    {$Event = $data}
    {load_templates "subtemplates.tpl"}

    <div class="page-header">
        <ol class="breadcrumb">
            <li><a href="/events">{_ "Events"}</a></li>
            <li>{tif $Event->EndTime > $.now ? 'Upcoming' : 'Past'}</li>
        </ol>
        <div class="btn-toolbar pull-right">
            {if $.User}
                <a class="btn btn-success" href="{$Event->getUrl(edit)}">{glyph "pencil"}&nbsp;{_ "Edit Event"}</a>
                <a class="btn btn-success" href="{$Event->getUrl('segments/*create')}">{glyph "plus"}&nbsp;{_ "Add Segment"}</a>
            {/if}
        </div>
        <h1>{$Event->Title|escape}</h1>
    </div>

    <div class="row">
        <div class="col-md-9">
            {if $Event->Description}
                <div class="content-markdown event-description well">{$Event->Description|escape|markdown}</div>
            {/if}

            {if $Event->Segments}
                <section class="event-segments">
                    <h2>Schedule</h2>

                    {$lastDate = null}
                    {$lastLocationName = null}
                    {$lastLocationAddress = null}

                    {foreach item=Segment from=$Event->Segments}
                        {$thisDate = date("l, F jS", $Segment->StartTime)}

                        {if $lastDate != $thisDate}
                            {if $lastDate}
                                </dl>
                            {/if}
                            <h3>{$thisDate}</h3>
                            <dl class="dl-horizontal">
                            {$lastDate = $thisDate}
                            {$lastLocationName = null}
                            {$lastLocationAddress = null}
                        {/if}
                                {if
                                    (
                                        $Segment->LocationName != $lastLocationName
                                        || $Segment->LocationAddress != $lastLocationAddress
                                    )
                                    && ($Segment->LocationName || $Segment->LocationAddress)
                                }
                                    <div class="event-location">
                                        <dt>{icon "map-marker"}</dt>
                                        <dd>{eventLocation name=$Segment->LocationName address=$Segment->LocationAddress}</dd>
                                    </div>
                                {/if}
                                <dt>{time_range $Segment->StartTime $Segment->EndTime}</dt>
                                <dd>
                                    <h4><a href="{$Segment->getUrl()}">{$Segment->Title|escape}</a></h4>
                                    <div class="content-markdown event-segment-description">{$Segment->Description|escape|markdown}</div>
                                </dd>

                        {$lastLocationName = $Segment->LocationName}
                        {$lastLocationAddress = $Segment->LocationAddress}
                    {/foreach}
                </foreach>
            {/if}
        </div>
        
        <dl class="event-details col-md-3">
            {if $Event->Status != 'published'}
                <dt>Status</dt>
                <dd>{$Event->Status}</dd>
            {/if}

            <dt>Starts</dt>
            <dd>{timestamp $Event->StartTime time='auto'}</dd>

            {if $Event->EndTime}
                <dt>Ends</dt>
                <dd>{timestamp $Event->EndTime time='auto'}</dd>
            {/if}

            {if $Event->LocationName || $Event->LocationAddress}
                <dt>Location</dt>
                <dd>{eventLocation name=$Event->LocationName address=$Event->LocationAddress}</dd>
            {/if}
        </dl>
    </div>
{/block}