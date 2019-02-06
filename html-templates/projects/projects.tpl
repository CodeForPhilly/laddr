{extends designs/site.tpl}

{block title}{_ "Projects"} &mdash; {$dwoo.parent}{/block}

{block js-bottom}
    {$dwoo.parent}
    {jsmin "features/sidebar-tags.js"}
{/block}

{block content}
    <header class="page-header">
        <div class="btn-toolbar pull-right">
            {if $.User}
                <form action="/projects/create">
                    <button class="btn btn-success" type="submit">{glyph "plus"}&nbsp;{_ "Add Project&hellip;"}</button>
                </form>
            {else}
                <a href="/register" class="btn btn-danger">{glyph "fire"}&nbsp;{_ "Register with the Brigade!"}</a>
            {/if}
        </div>
        <h1>{_ "Civic Projects Directory"} <span class="badge">{$projectsTotal|number_format}</span></h1>
    </header>

    {contentBlock "projects-browse-introduction"}

    <div class="row">
        <div class="col-sm-4 col-md-3">
            
            <form id="add-application" class="" tabindex="-1" role="dialog" aria-labelledby="add-member-title" action="/projects/{$Project->Handle}/add-application" method="POST">
                <div class="radio list-group">
                    <label>
                        <input type="checkbox" name="stage[]" value="Commenting" checked>
                        <b>{_ Commenting}</b>: {Laddr\Project::getStageDescription(Commenting)}
                    </label>
                </div>
                <div class="radio list-group">
                    <label>
                        <input type="checkbox" name="stage[]" value="Bootstrapping" checked>
                        <b>{_ Bootstrapping}</b>: {Laddr\Project::getStageDescription(Bootstrapping)}
                    </label>
                </div>
                <div class="radio list-group">
                    <label>
                        <input type="checkbox" name="stage[]" value="Prototyping" checked>
                        <b>{_ Prototyping}</b>: {Laddr\Project::getStageDescription(Prototyping)}
                    </label>
                </div>
                <div class="radio list-group">
                    <label>
                        <input type="checkbox" name="stage[]" value="Testing" checked>
                        <b>{_ Testing}</b>: {Laddr\Project::getStageDescription(Testing)}
                    </label>
                </div>
                <div class="radio list-group">
                    <label>
                        <input type="checkbox" name="stage[]" value="Maintaining" checked>
                        <b>{_ Maintaining}</b>: {Laddr\Project::getStageDescription(Maintaining)}
                    </label>
                </div>
                <div class="radio list-group">
                    <label>
                        <input type="checkbox" name="stage[]" value="Drifting" checked>
                        <b>{_ Drifting}</b>: {Laddr\Project::getStageDescription(Drifting)}
                    </label>
                </div>
                <div class="radio list-group">
                    <label>
                        <input type="checkbox" name="stage[]" value="Hibernating">
                        <b>{_ Hibernating}</b>: {Laddr\Project::getStageDescription(Hibernating)}
                    </label>
                </div>
                <div class="">
                        <button class="btn btn-primary">{_ "Apply"}</button>
                </div>
            </form>

        
            <div class="tags-ct">
                <div class="btn-group btn-group-justified btn-group-xs margin-bottom" role="group">
                    <a href="#projects-by-topic" class="active btn btn-default" role="button" data-group="byTopic">{_ "topics"}</a>
                    <a href="#projects-by-tech" class="btn btn-default" role="button" data-group="byTech">{_ "tech"}</a>
                    <a href="#projects-by-event" class="btn btn-default" role="button" data-group="byEvent">{_ "events"}</a>
                </div>
    
                {template tagLink tagData rootUrl linkCls=""}
                    <a class="{$linkCls}" href="{$rootUrl}?tag={$tagData.Handle}">{$tagData.Title}{if $tagData.itemsCount} <span class="badge pull-right">{$tagData.itemsCount|number_format}</span>{/if}</a>
                {/template}
    
                <div class="tags list-group byTopic">
                    {foreach item=tag from=$projectsTags.byTopic}
                        {tagLink tagData=$tag rootUrl="/projects" linkCls="list-group-item"}
                    {/foreach}
                </div>
                <div class="tags list-group byTech" style="display: none">
                    {foreach item=tag from=$projectsTags.byTech}
                        {tagLink tagData=$tag rootUrl="/projects" linkCls="list-group-item"}
                    {/foreach}
                </div>
                <div class="tags list-group byEvent" style="display: none">
                    {foreach item=tag from=$projectsTags.byEvent}
                        {tagLink tagData=$tag rootUrl="/projects" linkCls="list-group-item"}
                    {/foreach}
                </div>
            </div>
        </div>
        <div class="col-sm-8 col-md-9">
            {foreach item=Project from=$data}
                <article class="post panel panel-default">
                    <div class="panel-body">
                        <h2 class="post-title">
                            <a name="{$Project->Handle}" href="{$Project->getURL()}">{$Project->Title|escape}</a>
                            {if $Project->Stage}
                                <span class="label label-info">{_ "$Project->Stage"}</span>
                            {/if}
                        </h2>
                        <div class="well">
                            {if $Project->README}
                                <div class="content-markdown content-readme">{$Project->README|truncate:600|escape|markdown}</div>
                            {/if}
                        </div>
                        {if $Project->Memberships}
                            <ul class="list-inline people-list">
                            {foreach item=Membership from=$Project->Memberships}
                                {$Member = $Membership->Member}
                                <li class="people-list-person {tif $Project->MaintainerID == $Member->ID ? maintainer}">
                                    <a
                                        href="/members/{$Member->Username}"
                                        class="member-thumbnail"
                                        data-toggle="tooltip"
                                        title="{personName $Member} &mdash; {projectMemberTitle $Membership}"
                                    >
                                        {if $Project->MaintainerID == $Member->ID}
                                            {avatar $Member size=64}
                                        {else}
                                            {avatar $Member size=48}
                                        {/if}
                                    </a>
                                </li>
                            {foreachelse}
                                <li class="muted">{_ "No registered members"}</li>
                            {/foreach}
                            </ul>
                        {/if}
                        <div class="btn-group post-link-group" role="group">
                            {if $Project->UsersUrl}<a class="btn btn-primary" role="button" href="{$Project->UsersUrl|escape}">{glyph "link"}&nbsp;Public Site</a>{/if}
                            {if $Project->DevelopersUrl}<a class="btn btn-success" role="button" href="{$Project->DevelopersUrl|escape}">{glyph "link"}&nbsp;Developers</a>{/if}
                        </div>
                    </div>
                </article>
            {foreachelse}
                <em>No projects were found, try creating one{if count($conditions)} or <a href="?">browse without any filters</a>{/if}.</em>
            {/foreach}
        </div>
    </div>
{/block}
