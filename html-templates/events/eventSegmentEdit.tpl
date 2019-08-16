{extends designs/site.tpl}

{block title}{if $data->isPhantom}{_ 'Create'}{else}{_('Edit %s')|sprintf:$data->Title|escape}{/if} &mdash; {_ 'Events'} &mdash; {$dwoo.parent}{/block}

{block js-bottom}
    {$dwoo.parent}
    {jsmin "lib/epiceditor.js"}
    {jsmin "pages/event-edit.js"}
{/block}

{block content}
    {$Segment = $data}
    {$Event = $Segment->Event}

    <div class="container">
        <div class="page-header">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/events">{_ "Events"}</a></li>
                <li class="breadcrumb-item"><a href="{$Event->getUrl()}">{$Event->Title|escape}</a></li>
                <li class="breadcrumb-item"><a href="{$Segment->getUrl()}">{$Segment->Title|escape}</a></li>
                <li class="breadcrumb-item active">Edit</li>
            </ol>

            <h1>
                {if $Segment->isPhantom}
                    {_ "Create new event segment"}
                {else}
                    {_("Edit event segment")} <strong>{$Segment->Title|escape}</strong>
                {/if}
            </h1>
        </div>

        <div class="row">
            <div class="col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">
                {if !$Segment->isValid}
                    <div class="error well">
                        <strong>{_ "There were problems with your entry:"}</strong>
                        <ul class="errors">
                        {foreach item=error key=field from=$Segment->validationErrors}
                            <li>{$error}</li>
                        {/foreach}
                        </ul>
                    </div>
                {/if}

                <form method="POST">
                    <div class="form-group">
                        <label for="field-event">{_ "Event"}:</label>
                        <select name="EventID" id="field-event" class="form-control">
                            {foreach item=Event from=Emergence\Events\Event::getAll(array(Order=StartTime))}
                                <option value="{$Event->ID}" {refill field=EventID default=$Segment->EventID selected=$Event->ID}>{date('Y-m-d', $Event->StartTime)}: {$Event->Title|escape}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="field-title">{_ "Title"}:</label>
                        <input name="Title" id="field-title" class="form-control form-control-lg" placeholder="{_ 'Opening Remarks'}" value="{refill field=Title default=$Segment->Title}" />
                    </div>
                    <div class="form-group">
                        <label for="field-handle">{_ "Handle"} ({_ "optional"}):</label>
                        <input name="Handle" id="field-handle" class="form-control" placeholder="{_ 'opening-remarks'}" value="{refill field=Handle default=$Segment->Handle}" />
                        <small class="form-text text-muted">Must be unique &mdash; leave blank to auto-generate</small>
                    </div>
                    <div class="form-row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="field-time-start">{_ "Start time"}:</label>
                                <input type="datetime-local" name="StartTime" id="field-time-start" class="form-control" value="{refill field=StartTime default=tif($Segment->StartTime, date('Y-m-d\TH:i', $Segment->StartTime))}"/>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="field-time-end">{_ "End time"}:</label>
                                <input type="datetime-local" name="EndTime" id="field-time-end" class="form-control" value="{refill field=EndTime default=tif($Segment->EndTime, date('Y-m-d\TH:i', $Segment->EndTime))}"/>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="field-location-name">{_ "Location name"}:</label>
                        <input type="text" name="LocationName" id="field-location-name" class="form-control" placeholder="Localhost" value="{refill field=LocationName default=$Segment->LocationName}"/>
                    </div>
                    <div class="form-group">
                        <label for="field-location-address">{_ "Location address"}:</label>
                        <input type="text" name="LocationAddress" id="field-location-address" class="form-control" placeholder="908 N 3rd St, Philadelphia PA" value="{refill field=LocationAddress default=$Segment->LocationAddress}"/>
                    </div>

                    <div class="form-group">
                        <label for="field-summary">{_ 'Summary(.md)'}</label>
                        <div class="controls">
                            <textarea name="Summary" class="form-control" rows="10">{refill field=Summary default=$Event->Summary}</textarea>
                            <small class="form-text text-muted">
                                If provided, a summary will be shown directly under this event segment in the full schedule. Keep it short and sweet!
                            </small>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="field-description">{_ 'Description(.md)'}</label>
                        <div class="controls">
                            <textarea name="Description" class="form-control" rows="10">{refill field=Description default=$Segment->Description}</textarea>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">{if $Segment->isPhantom}{_ 'Create Event Segment'}{else}{_ 'Save Changes'}{/if}</button>
                </form>
            </div>
        </div>
    </div>
{/block}
