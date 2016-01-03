{extends designs/site.tpl}

{block title}{_ "Projects"} &mdash; {$dwoo.parent}{/block}

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

        <h2>{_ "Civic Projects Directory"}</h2>
    </header>

    {foreach item=Project from=$data}
        <div class="project-listing row-fluid clearfix">
            <div class="col-sm-8">
                <h3>
                    <a name="{$Project->Handle}" href="{$Project->getURL()}">{$Project->Title|escape}</a>
                </h3>

                <div class="well">
                    {if $Project->README}
                        <div class="markdown readme">{$Project->README|truncate:600|escape|markdown}</div>
                    {/if}
                </div>
            </div>

            <div class="col-sm-4">
                <h4>Project Info</h4>
                

                <div class="btn-group btn-group-justified" role="group">
                    {if $Project->UsersUrl}<a class="btn btn-primary" role="button" href="{$Project->UsersUrl|escape}">{glyph "link"}&nbsp;Public Site</a>{/if}
                    {if $Project->DevelopersUrl}<a class="btn btn-success" role="button" href="{$Project->DevelopersUrl|escape}">{glyph "link"}&nbsp;Developers</a>{/if}
                </div>
            
                {if $Project->Stage}
                    Stage: <span class="label label-info">{_ "$Project->Stage"}</span>
                {/if}
            
                {if $Project->Memberships}

                <h4>{_ "Members"}</h4>

                <ul class="list-inline people-list">
                {foreach item=Membership from=$Project->Memberships}
                    {$Member = $Membership->Member}
                    <li class="listed-person {tif $Project->MaintainerID == $Member->ID ? maintainer}">
                        <a
                            href="/members/{$Member->Username}"
                            class="member-thumbnail"
                            data-toggle="tooltip"
                            title="{personName $Member} &mdash; {projectMemberTitle $Membership}"
                        >
                            {avatar $Member size=48}
                        </a>
                    </li>
                {foreachelse}
                    <li class="muted">{_ "None registered"}</li>
                {/foreach}
                </ul>
                {/if}
            </div>
        </div> <!-- .row-fluid -->
        <hr>
    {foreachelse}
        <em>No projects were found, try creating one{if count($conditions)} or <a href="?">browse without any filters</a>{/if}.</em>
    {/foreach}
{/block}
