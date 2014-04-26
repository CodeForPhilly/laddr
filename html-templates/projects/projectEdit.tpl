{extends designs/site.tpl}

{block title}{if $data->isPhantom}Create{else}Edit {$data->Title|escape}{/if} &mdash; Projects &mdash; {$dwoo.parent}{/block}

{block js-bottom}
    {$dwoo.parent}
    <script>
        var tagTitles = {Tag::getAllTitles()|json_encode};
    </script>
    {jsmin "epiceditor.js"}
    {jsmin "pages/project-edit.js"}
{/block}

{block content}
    {$Project = $data}

    <h2>
        {if $Project->isPhantom}
            Create new project
        {else}
            Edit project <strong>{$Project->Title|escape}</strong>
        {/if}
    </h2>

    {if !$Project->isValid}
    <div class="error well">
        <strong>There were problems with your entry:</strong>
        <ul class="errors">
        {foreach item=error key=field from=$Project->validationErrors}
            <li>{$error}</li>
        {/foreach}
        </ul>
    </div>
    {/if}


    <form method="POST" class="form-horizontal">
        <div class="control-group">
            <label for="field-title" class="control-label">Title:</label>
            <div class="controls">
                <input name="Title" id="field-title" placeholder="Train Schedule Analyzer"
                    value="{refill field=Title default=$Project->Title}" />
            </div>
        </div>
        <div class="control-group">
            <label for="field-url-users" class="control-label">Users' URL:</label>
            <div class="controls">
                <input name="UsersUrl" id="field-url-users" placeholder="http://mypublicapp.org"
                 value="{refill field=UsersUrl default=$Project->UsersUrl}"/>
            </div>
        </div>
        <div class="control-group">
            <label for="field-url-developers" class="control-label">Developers' URL:</label>
            <div class="controls">
                <input name="DevelopersUrl" id="field-url-developers" placeholder="http://github.com/..." value="{refill field=DevelopersUrl default=$Project->DevelopersUrl}"/>
            </div>
        </div>
        <div class="control-group">
            <label for="tagsInput" class="control-label">Tags:</label>
            <div class="controls">
                <input id="tagsInput" name="tags" placeholder="tech.php, topic.outdoors" value="{refill field=tags default=Tag::getTagsString($Project->Tags)}"/>
            </div>
        </div>
        <div class="control-group">
            <label for="README" class="control-label">README(.md)</label>
            <div class="controls">
                <textarea name="README" class="input-block-level" rows="10">{refill field=README default=$Project->README}</textarea>
                <br/><br/>
                <input type="submit" class="btn-small btn" value="{tif $Project->isPhantom ? 'Create Project' : 'Save Changes'}"/>
            </div>
        </div>
    </form>
{/block}