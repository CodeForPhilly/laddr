{extends "designs/site.tpl"}

{block title}{_ 'Event'} &mdash; {$dwoo.parent}{/block}

{block content}
    {$Event = $data}

    <div class="page-header">
        {*
        <ol class="breadcrumb">
            <li><a href="/events">{_ "Events"}</a></li>
            <li><a href="{$Event->getUrl()}">{$Event->Title|escape}</a></li>
        </ol>
        *}
        <div class="btn-toolbar pull-right">
            {if $.User}
                <form action="{$Event->getUrl(edit)}">
                    <button class="btn btn-success" type="submit">{glyph "pencil"}&nbsp;{_ "Edit Event&hellip;"}</button>
                </form>
            {/if}
        </div>
        <h1>{$Event->Title|escape}</h1>
    </div>
    <div class="row">
        <div class="col-md-3">
            <ul class="row list-unstyled">
                {if $Event->Status != 'published'}
                    <li class="col-sm-3 col-md-12">
                        <p>
                            <b>Status</b><br/>
                            {$Event->Status}
                        </p>
                    </li>
                {/if}

                <li class="col-sm-3 col-md-12">
                    <p>
                        <b>Start time</b><br/>
                        {timestamp $Event->StartTime time=yes}
                    </p>
                </li>

                {if $Event->EndTime}
                <li class="col-sm-3 col-md-12">
                    <p>
                        <b>End time</b><br/>
                        {timestamp $Event->EndTime time=yes}
                    </p>
                </li>
                {/if}

                {if $Event->Location}
                <li class="col-sm-3 col-md-12">
                    <p>
                        <b>Location</b><br/>
                        <a href="https://www.google.com/maps?q={$Event->Location|escape:url}">{$Event->Location|escape}</a>
                    </p>
                </li>
                {/if}
            </ul>
        </div>

        <div class="col-md-9">
            {if $Event->Description}
                <div class="well">
                    <div class="content-markdown event-description">{$Event->Description|truncate:600|escape|markdown}</div>
                </div>
            {/if}

            {if $Event->Segments}
                <h2>Segments</h2>

                {$lastDate = null}

                {foreach item=Segment from=$Event->Segments}
                    {$thisDate = date("l, F jS", $Segment->StartTime)}

                    {if $lastDate != $thisDate}
                        {if $lastDate}
                            </dl>
                        {/if}
                        <h3>{$thisDate}</h3>
                        <dl class="dl-horizontal">
                        {$lastDate = $thisDate}
                    {/if}
                            <dt>{time_range $Segment->StartTime $Segment->EndTime}</dt>
                            <dd>
                                <a href="{$Event->getUrl("segments/$Segment->Handle")}">{$Segment->Title|escape}</a>
                                {if $Segment->LocationName || $Segment->LocationAddress}
                                    <p>
                                        <strong>Location</strong>
                                        <a target="_blank" href="https://maps.google.com?q={implode(', ', array_filter(array($Segment->LocationName, $Segment->LocationAddress)))|escape:url}">
                                            {if $Segment->LocationName && $Segment->LocationAddress}
                                                {$Segment->LocationName|escape} ({$Segment->LocationAddress|escape})
                                            {else}
                                                {$Segment->LocationName|default:$Segment->LocationAddress|escape}
                                            {/if}
                                        </a>
                                    </p>
                                {/if}
                                <div class="content-markdown event-segment-description">{$Segment->Description|escape|markdown}</div>
                            </dd>
                {/foreach}
            {/if}
        </div>
    </div>
{/block}