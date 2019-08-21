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

        .event-segment__day-of-week {
            font-variant-caps: all-small-caps;
            font-weight: bold;
            margin-right: .25em;
        }

        .event-segment__location {
            font-size: smaller;
        }

        .event-segment__time {
            color: black;
            font-variant-numeric: oldstyle-nums;
        }

        .event-segment__summary p {
            margin: 0;
        }

        .event-segment__title {
            font-size: 1rem;
            font-weight: normal;
            line-height: inherit;
            margin: 0;
        }
    </style>
{/block}

{block content}
    {$Event = $data}

    <div class="page-header">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/events">{_ "Events"}</a></li>
            <li class="breadcrumb-item active">{tif $Event->EndTime > $.now ? 'Upcoming' : 'Past'}</li>
        </ol>
        {if $.User}
            <div class="btn-toolbar pull-right mt-1">
                <a class="btn btn-secondary mr-2" href="{$Event->getUrl(edit)}">{icon "pencil"}&nbsp;{_ "Edit Event"}</a>
                <a class="btn btn-secondary" href="{$Event->getUrl(segments/!create)}">{icon "plus-square-o"}&nbsp;{_ "Add Segment"}</a>
            </div>
        {/if}

        <h1>{$Event->Title|escape}</h1>

        <dl class="event-details row">
            {if $Event->Status != 'published'}
                <div class="col-md-2">
                    <dt>Status</dt>
                    <dd>{$Event->Status}</dd>
                </div>
            {/if}

            <div class="col-md-2">
                <dt>Starts</dt>
                <dd>{timestamp $Event->StartTime time='auto'}</dd>
            </div>

            {if $Event->EndTime}
                <div class="col-md-2">
                    <dt>Ends</dt>
                    <dd>{timestamp $Event->EndTime time='auto'}</dd>
                </div>
            {/if}

            {if $Event->LocationName || $Event->LocationAddress}
                <div class="col-md-2">
                    <dt>Location</dt>
                    <dd class="d-flex my-2 align-items-baseline">
                        <div class="text-danger mr-2">{icon "map-marker" fa-fw}</div>
                        <div class="flex-fill event-segment__location">{eventLocation name=$Segment->LocationName
                            address=$Segment->LocationAddress
                            linkCls='text-secondary'}
                        </div>
                    </dd>
                </div>
            {/if}
        </dl>
    </div>

    <div class="row">
        {if $Event->Description}
            <div class="col-md-7">
                <a href="#schedule" class="d-inline-block d-md-none mb-3">See the schedule {icon "level-down"}</a>
                <div
                    class="content-markdown event-description content-editable"
                    {if $.User->hasAccountLevel('Staff')}
                        data-content-endpoint="/events"
                        data-content-id="{$Event->Handle}"
                        data-content-field="Description"
                        data-content-value="{$Event->Description|escape}"
                        data-content-renderer="markdown"
                    {/if}
                >
                    {$Event->Description|escape|markdown}
                </div>
            </div>
        {/if}

        {if $Event->Segments}
            <div id="schedule" class="col-md-5 col-lg-4 offset-lg-1 pt-5 pt-md-0">
                <section class="event-segments">
                    <h2 class="h4">Schedule</h2>

                    {$lastDate = null}
                    {$lastLocationName = null}
                    {$lastLocationAddress = null}

                    <ol class="list-unstyled">
                        {foreach item=Segment from=$Event->Segments}
                            <li class="event-segment my-3" id="{unique_dom_id}{$Segment->Handle}{/unique_dom_id}">
                                {$thisDate = date("l, F jS", $Segment->StartTime)}

                                {if $lastDate != $thisDate}
                                    <h3 class="h5 font-weight-normal" id="{date("Y-m-d", $Segment->StartTime)}">
                                        <span class="event-segment__day-of-week">{date("l", $Segment->StartTime)},</span>
                                        {date("F jS", $Segment->StartTime)}
                                    </h3>

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
                                    <div class="d-flex my-2 align-items-baseline">
                                        <div class="text-danger mr-2">{icon "map-marker" fa-fw}</div>
                                        <div class="flex-fill event-segment__location">{eventLocation name=$Segment->LocationName
                                            address=$Segment->LocationAddress
                                            linkCls='text-secondary'}
                                        </div>
                                    </div>
                                {/if}

                                <div class="d-flex align-items-baseline">
                                    <div class="mr-2">{icon "clock-o" fa-fw}</div>
                                    <div class="flex-fill">
                                        <div class="event-segment__time">{time_range $Segment->StartTime $Segment->EndTime}</div>

                                        <h4 class="event-segment__title">
                                            <a class="text-info" href="{$Segment->getUrl()}">
                                                {$Segment->Title|escape}
                                                {if $Segment->Description}{icon "angle-right" ml-1}{/if}
                                            </a>
                                        </h4>

                                        {if $Segment->Summary}
                                            <div
                                                class="content-markdown event-segment__summary content-editable text-secondary"
                                                {if $.User->hasAccountLevel('Staff')}
                                                    data-content-endpoint="{$Event->getUrl(segments)}"
                                                    data-content-id="{$Segment->Handle}"
                                                    data-content-field="Summary"
                                                    data-content-value="{$Segment->Summary|escape}"
                                                    data-content-renderer="markdown"
                                                {/if}
                                            >
                                                {$Segment->Summary|escape|markdown}
                                            </div>
                                        {/if}
                                    </div>
                                </div>

                                {$lastLocationName = $Segment->LocationName}
                                {$lastLocationAddress = $Segment->LocationAddress}
                            </li>
                        {/foreach}
                    </ol>
                </section>
            </div>
        {/if}
    </div>
{/block}
