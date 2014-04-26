{extends designs/site.tpl}

{block title}{if $data->isPhantom}Create{else}Edit {$data->Title|escape}{/if} &mdash; Project Update &mdash; {$dwoo.parent}{/block}

{block content}
    {$Update = $data}

    <h2>
        {if $Update->isPhantom}
            Create new project upate
        {else}
            Edit <a href="/projects/{$Update->Project->Handle}/updates/{$Update->Number}">Update #{$Update->Number}</a>
        {/if}
    </h2>

    <form method="POST" class="form-horizontal">
        <div class="control-group">
            <label for="UpdateBody" class="control-label">Update</label>
            <div class="controls">
                <textarea name="Body" class="input-block-level" rows="10" id="UpdateBody">{refill field=Body default=$Update->Body}</textarea>
                <br/><br/>
                <input type="submit" class="btn-small btn" value="{tif $Update->isPhantom ? 'Post Update' : 'Save Changes'}"/>
            </div>
        </div>
    </form>
{/block}

{block js-bottom}
    {$dwoo.parent}
    {jsmin "epiceditor.js"}
    {jsmin "pages/update-edit.js"}
{/block}