{extends designs/site.tpl}

{block title}{if $data->isPhantom}Create{else}Edit {$data->Headline|escape}{/if} &mdash; Buzz &mdash; {$dwoo.parent}{/block}

{block content}
    {$Buzz = $data}

    <h2>
        {if $Buzz->isPhantom}
            Log new buzz
        {else}
            Edit buzz <strong>{$Buzz->Headline|escape}</strong>
        {/if}
    </h2>

    {if !$Buzz->isValid}
    <div class="error well">
        <strong>There were problems with your entry:</strong>
        <ul class="errors">
        {foreach item=error key=field from=$Buzz->validationErrors}
            <li>{$error}</li>
        {/foreach}
        </ul>
    </div>
    {/if}

    <form method="POST" class="form-horizontal" enctype="multipart/form-data">
        <div class="control-group">
            <label for="field-project" class="control-label">Project:</label>
            <div class="controls">
                <select name="ProjectID" class="project-picker" id="field-project">
                    <option value="">Select Project</option>
                    {foreach item=Project from=Laddr\Project::getAll()}
                        <option value="{$Project->ID}" {refill field=ProjectID default=$Buzz->ProjectID selected=$Project->ID}>{$Project->Title|escape}</option>
                    {/foreach}
                </select>
            </div>
        </div>
        <div class="control-group">
            <label for="field-headline" class="control-label">Headline:</label>
            <div class="controls">
                <input name="Headline" id="field-headline" placeholder="City Times headline on Budget Project"
                    value="{refill field=Headline default=$Buzz->Headline}" class="input-block-level">
            </div>
        </div>
        <div class="control-group">
            <label for="field-url" class="control-label">URL:</label>
            <div class="controls">
                <input name="URL" id="field-url" placeholder="http://citytimes.com/2014/04/28/civic-hackers-analyze-budget"
                 value="{refill field=URL default=$Buzz->URL}" class="input-block-level">
            </div>
        </div>
        <div class="control-group">
            <label for="field-published-date" class="control-label">Publish date/time:</label>
            <div class="controls">
                <input id="field-published-date" type="date" name="Published[date]" placeholder="YYYY-MM-DD" value="{refill field=Published.date default=tif($Buzz->Published, date('Y-m-d', $Buzz->Published))}">
                <input type="time" name="Published[time]" placeholder="HH:MM" value="{refill field=Published.time default=tif($Buzz->Published, date('H:i', $Buzz->Published))}">
            </div>
        </div>
        <div class="control-group">
            <label for="field-image" class="control-label">Image</label>
            <div class="controls">
                <input name="image" id="field-image" type="file">
                <span class="help-inline">Optional</span>
            </div>
        </div>
        <div class="control-group">
            <label for="field-summary" class="control-label">Summary</label>
            <div class="controls">
                <textarea name="Summary" class="input-xxlarge" rows="10" id="field-summary">{refill field=Summary default=$Buzz->Summary}</textarea>
                <span class="help-inline">Optional</span>
            </div>
        </div>
        <div class="control-group">
            <div class="controls">
                <input type="submit" class="btn-sm btn btn-primary" value="{tif $Buzz->isPhantom ? 'Create Buzz' : 'Save Changes'}"/>
            </div>
        </div>
    </form>
{/block}

{block js-bottom}
    {$dwoo.parent}
    {jsmin "pages/buzz-edit.js"}
{/block}