{extends designs/site.tpl}

{block title}{if $data->isPhantom}{_ 'Create'}{else}{_('Edit %s')|sprintf:$data->Title|escape}{/if} &mdash; {_ 'Events'} &mdash; {$dwoo.parent}{/block}

{block js-bottom}
    {$dwoo.parent}
    {jsmin "lib/epiceditor.js"}
    {jsmin "pages/event-edit.js"}
{/block}

{block content}
    {$Event = $data}

    <div class="container">
        <div class="page-header">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/events">{_ "Events"}</a></li>
                <li class="breadcrumb-item"><a href="{$Event->getUrl()}">{$Event->Title|escape}</a></li>
                <li class="breadcrumb-item active">{_ Edit}</li>
            </ol>

            <h1>
                {if $Event->isPhantom}
                    {_ "Create new event"}
                {else}
                    {_("Edit event")} <strong>{$Event->Title|escape}</strong>
                {/if}
            </h1>
        </div>

        <div class="row">
            <div class="col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">

                {if !$Event->isValid}
                    <div class="error well">
                        <strong>{_ "There were problems with your entry:"}</strong>
                        <ul class="errors">
                        {foreach item=error key=field from=$Event->validationErrors}
                            <li>{$error}</li>
                        {/foreach}
                        </ul>
                    </div>
                {/if}

                <form method="POST">
                    <div class="form-group">
                        <label for="field-title">{_ "Title:"}</label>
                        <input name="Title" id="field-title" class="form-control form-control-lg" placeholder="{_ 'Workshop #125'}" value="{refill field=Title default=$Event->Title}" />
                    </div>
                    <div class="form-group">
                        <label for="field-handle">{_ "Handle (optional):"}</label>
                        <input name="Handle" id="field-handle" class="form-control" placeholder="{_ 'workshop-125'}" value="{refill field=Handle default=$Event->Handle}" />
                        <small class="form-text text-muted">{_ "Must be unique &mdash; leave blank to auto-generate"}</small>
                    </div>
                    <div class="form-group">
                        <label for="field-status">{_ "Status:"}</label>
                        <select name="Status" id="field-status" class="form-control">
                            {foreach item=status from=Emergence\Events\Event::getFieldOptions(Status, values)}
                                <option {refill field=Status default=$Event->Status selected=$status}>{$status}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="form-row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="field-time-start">{_ "Start time:"}</label>
                                <input type="datetime-local" name="StartTime" id="field-time-start" class="form-control" value="{refill field=StartTime default=tif($Event->StartTime, date('Y-m-d\TH:i', $Event->StartTime))}"/>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="field-time-end">{_ "End time:"}</label>
                                <input type="datetime-local" name="EndTime" id="field-time-end" class="form-control" value="{refill field=EndTime default=tif($Event->EndTime, date('Y-m-d\TH:i', $Event->EndTime))}"/>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="field-location-name">{_ "Location name:"}</label>
                        <input type="text" name="LocationName" id="field-location-name" class="form-control" placeholder="Localhost" value="{refill field=LocationName default=$Event->LocationName}"/>
                    </div>
                    <div class="form-group">
                        <label for="field-location-address">{_ "Location address:"}</label>
                        <input type="text" name="LocationAddress" id="field-location-address" class="form-control" placeholder="908 N 3rd St, Philadelphia PA" value="{refill field=LocationAddress default=$Event->LocationAddress}"/>
                    </div>

                    <div class="form-group">
                        <label for="field-description">{_ 'Description(.md)'}</label>
                        <div class="controls">
                            <textarea name="Description" class="form-control" rows="10">{refill field=Description default=$Event->Description}</textarea>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">{if $Event->isPhantom}{_ 'Create Event'}{else}{_ 'Save Changes'}{/if}</button>
                </form>
            </div>
        </div>
    </div>
{/block}
