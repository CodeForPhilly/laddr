{extends "designs/site.tpl"}

{block title}{_ 'Event'} &mdash; {$dwoo.parent}{/block}

{block content}
    {$Event = $data}

    <header class="page-header">
        <div class="btn-toolbar pull-right">
            {if $.User}
                <form action="{$Event->getUrl(edit)}">
                    <button class="btn btn-success" type="submit">{glyph "pencil"}&nbsp;{_ "Edit Event&hellip;"}</button>
                </form>
            {/if}
        </div>
        <h1><a href="/events">{_ "Events"}</a>&nbsp;&raquo; <a href="{$Event->getUrl()}">{$Event->Title|escape}</a></h1>
    </header>

    <article class="post panel panel-default">
        <div class="panel-body">
            <dl class="dl-horizontal">
                {if $Event->Status != 'published'}
                    <dt>Status</dt>
                    <dd><strong>{$Event->Status}</strong></dd>
                {/if}

                <dt>Start time</dt>
                <dd>{timestamp $Event->StartTime time=yes}</dd>

                {if $Event->EndTime}
                    <dt>End time</dt>
                    <dd>{timestamp $Event->EndTime time=yes}</dd>
                {/if}

                {if $Event->Location}
                    <dt>Location</dt>
                    <dd><a href="https://www.google.com/maps?q={$Event->Location|escape:url}">{$Event->Location|escape}</a></dd>
                {/if}

                {if $Event->Description}
                    <dt>Description</dt>
                    <dd class="well">
                        <div class="markdown event-description">{$Event->Description|truncate:600|escape|markdown}</div>
                    </dd>
                {/if}

                {if $Event->Segments}
                    <dt>Segments</dt>
                    <dd>
                        <dl class="dl-horizontal">
                            {$lastDate = null}
                            {foreach item=Segment from=$Event->Segments}
                                {$thisDate = date("l<\\b\\r>F jS", $Segment->StartTime)}
                                {if $lastDate != $thisDate}
                                    {if $lastDate}
                                        </dl>
                                    </dd>
                                    {/if}
                                    <dt>{$thisDate}</dt>
                                    <dd>
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
                                    {$Segment->Description|escape|markdown}
                                </dd>

                            {/foreach}
                            </dl></dd>
                        </dl>
                    </dd>
                {/if}
            </dl>
        </div>
    </article>
{/block}