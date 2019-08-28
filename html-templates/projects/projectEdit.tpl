{extends designs/site.tpl}

{block title}{if $data->isPhantom}{_ 'Create'}{else}{_('Edit %s')|sprintf:$data->Title|escape}{/if} &mdash; {_ 'Projects'} &mdash; {$dwoo.parent}{/block}

{block js-bottom}
    {$dwoo.parent}
    {jsmin "lib/epiceditor.js"}
    {jsmin "pages/project-edit.js"}
    {jsmin "features/tag-fields.js"}
{/block}

{block content}
    {$Project = $data}

    <div class="container">
        <div class="row">
            <div class="col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">
                <div class="page-header">
                    <h1>
                        {if $Project->isPhantom}
                            {_ "Create new project"}
                        {else}
                            {_("Edit project %s")|sprintf:$Project->Title|escape}
                        {/if}
                    </h1>
                </div>

                {contentBlock "projects-create-introduction"}

                {if !$Project->isValid}
                <div class="error well">
                    <strong>{_ "There were problems with your entry:"}</strong>
                    <ul class="errors">
                    {foreach item=error key=field from=$Project->validationErrors}
                        <li>{$error}</li>
                    {/foreach}
                    </ul>
                </div>
                {/if}

                <form method="POST">
                    <div class="form-group">
                        <label for="field-title">{_ "Title"}:</label>
                        <input name="Title" id="field-title" class="form-control" placeholder="{_ 'Train Schedule Analyzer'}" value="{refill field=Title default=$Project->Title}" autofocus />
                    </div>
                    <div class="form-group">
                        <label for="field-url-users">{_ "URL for Users"}:</label>
                        <input type="url" name="UsersUrl" id="field-url-users" class="form-control" placeholder="{_ 'http://mypublicapp.org'}" value="{refill field=UsersUrl default=$Project->UsersUrl}" />
                    </div>
                    <div class="form-group">
                        <label for="field-url-developers">{_ "URL for Developers"}:</label>
                        <input type="url" name="DevelopersUrl" id="field-url-developers" class="form-control" placeholder="http://github.com/..." value="{refill field=DevelopersUrl default=$Project->DevelopersUrl}"/>
                    </div>
                    <div class="form-group">
                        <label for="field-chat-channel">{_ "Chat Channel/Hashtag"}:</label>
                        <input name="ChatChannel" id="field-chat-channel" class="form-control" placeholder="train_schedule_analyzer" value="{refill field=ChatChannel default=$Project->ChatChannel}" pattern="[A-Za-z0-9_-]+" title="Hash tag containing only letters, numbers, dashes or underscores without leading #"/>
                    </div>

                    {tagsField Record=$Project prefix=topic label=_("Topic tags") placeholder=_("Education, Mapping, Crime")}
                    {tagsField Record=$Project prefix=tech label=_("Technology tags") placeholder=_("PHP, Bootstrap, JavaScript")}
                    {tagsField Record=$Project prefix=event label=_("Connected events") placeholder=_("Education Hackathon 2014")}

                    <p id="project-stage"><b>{_ 'Stage'}:</b></p>
                    <div aria-labelledby="project-stage">
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Commenting" {refill field=Stage default=$Project->Stage|default:Commenting checked=Commenting}>
                                <b>{_ Commenting}</b>: {Laddr\Project::getStageDescription(Commenting)}
                            </label>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Bootstrapping" {refill field=Stage default=$Project->Stage checked=Bootstrapping}>
                                <b>{_ Bootstrapping}</b>: {Laddr\Project::getStageDescription(Bootstrapping)}
                            </label>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Prototyping" {refill field=Stage default=$Project->Stage checked=Prototyping}>
                                <b>{_ Prototyping}</b>: {Laddr\Project::getStageDescription(Prototyping)}
                            </label>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Testing" {refill field=Stage default=$Project->Stage checked=Testing}>
                                <b>{_ Testing}</b>: {Laddr\Project::getStageDescription(Testing)}
                            </label>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Maintaining" {refill field=Stage default=$Project->Stage checked=Maintaining}>
                                <b>{_ Maintaining}</b>: {Laddr\Project::getStageDescription(Maintaining)}
                            </label>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Drifting" {refill field=Stage default=$Project->Stage checked=Drifting}>
                                <b>{_ Drifting}</b>: {Laddr\Project::getStageDescription(Drifting)}
                            </label>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Hibernating" {refill field=Stage default=$Project->Stage checked=Hibernating}>
                                <b>{_ Hibernating}</b>: {Laddr\Project::getStageDescription(Hibernating)}
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="README">{_ 'README(.md)'}</label>
                        <div class="controls">
                            <textarea name="README" class="input-block-level" rows="10">{refill field=README default=$Project->README}</textarea>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">{if $Project->isPhantom}{_ 'Create Project'}{else}{_ 'Save Changes'}{/if}</button>
                </form>
            </div>
        </div>
    </div>
{/block}
