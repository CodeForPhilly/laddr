{extends designs/site.tpl}

{block title}{$data->Title|escape} &mdash; {_ 'Projects'} &mdash; {$dwoo.parent}{/block}

{block content}
    {$Project = $data}

    <header class="page-header">
        <div class="btn-toolbar pull-right">
            <div class="btn-group">
                <a href="/projects/{$Project->Handle}/edit" class="btn btn-info">{_ "Edit Project"}</a>
                {if $.User}
                    <button class="btn btn-info dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
                    <ul class="dropdown-menu">
                        <li><a href="#add-member" data-toggle="modal">{_ "Add Member"}</a></li>
                        <li><a href="/project-buzz/create?ProjectID={$Project->ID}">{_ "Log Buzz"}</a></li>
                        {if $.User && ($Project->hasMember($.User) || $.Session->hasAccountLevel('Staff'))}
                            <li><a href="#post-update" data-toggle="modal">{_ "Post Update"}</a></li>
                        {/if}
                        {if $.Session->hasAccountLevel('Staff')}
                            <li><a href="#manage-members" data-toggle="modal">{_ "Manage Members"}</a></li>
                        {/if}
                    </ul>
                {/if}
            </div>
        </div>

        <h2>{$Project->Title|escape}</h2>
    </header>

    <div class="row">
        <article class="project col-md-8">
<!--  Unnecessary? Leave for screen readers?          
            <h3>{_ "Project Info"}</h3>  
-->

<!--  TODO: apply if conditions to button links to show/hide -->
<!--            
            <dl class="dl-horizontal">
                {if $Project->UsersUrl}
                    <dt>{_ "Users' URL"}</dt>
                    <dd><a href="{$Project->UsersUrl|escape}">{$Project->UsersUrl|escape}</a></dd>
                {/if}

                {if $Project->DevelopersUrl}
                    <dt>{_ "Developers' URL"}</dt>
                    <dd><a href="{$Project->DevelopersUrl|escape}">{$Project->DevelopersUrl|escape}</a></dd>
                {/if}
-->                
<!-- TODO: Lauren move inline styles for progressbar to laddr.css -->
                {if $Project->Stage}
                   <div> 
                        <dt>{_ "Stage"} <span class="glyphicon glyphicon-question-sign"></span></dt>
                        <dd>
                            <div class="progress" style="">
                                <span class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 20%" data-toggle="tooltip" data-placement="bottom" title="{Laddr\Project::getStageDescription($Project->Stage)}">
                                    <span>{$Project->Stage}</span>
                                </span>
                            </div>
                        </dd>
                   </div>     
                {/if}  
                {if $Project->README}
                    <dt>{_ "README"}</dt>
                    <dd class="markdown readme well">{$Project->README|escape|markdown}</dd>
                {/if}

                {*
                <dt>COMMENTS: </dt>
                <dd>
                    <form method="post" action="/projects/{$Project->Handle}/comment">
                    <textarea name="Message"></textarea>
                    <input type="submit" value="Submit">
                    </form>
                </dd>
                {foreach item=Comment from=$Project->$Comments}
                    <p>
                    {$Comment->Message}
                    </p>
                {/foreach}
                *}

            </dl>

{*
            {if ($.User && $Project->hasMember($.User))}
                <form action="/projects/{$Project->Handle}/json/create-request">
                    <button class="btn btn-success" type="submit">Need Help?&hellip;</button>
                </form>
            {/if}
*}

            <h3>
                {_ "Project Activity"}
                <div class="btn-group pull-right">
                    {if $.User && $Project->hasMember($.User)}
                        <a href="#post-update" class="btn btn-primary btn-sm" data-toggle="modal">{_ "Post Update"}</a>
                    {/if}
                    <a href="/project-buzz/create?ProjectID={$Project->ID}" class="btn btn-success btn-sm">{_ "Log Buzz"}</a>
                </div>
            </h3>

            {foreach item=Article from=$Project->getActivity()}
                {projectActivity $Article headingLevel=h4 showProject=no}
            {foreachelse}
                <em>{_ "This project doesn't have any activity yet, post an update or log some buzz!"}</em>
            {/foreach}
        </article>
        
    <!--  PROJECT INFO  -->  
        <aside class="col-md-4">
            <h3>{_ "Project Info"}</h3>
        </aside>    
    <!--  PROJECT LINKS  -->  
        <aside class="col-md-4">
            <div class="btn-group btn-group-justified" role="group" aria-label="...">
              <a class="btn btn-primary" role="button" href="{$Project->UsersUrl|escape}"><span class="glyphicon glyphicon-link" style="margin-right:7px;"></span>Public Site</a>
              <a class="btn btn-success" role="button" href="{$Project->DevelopersUrl|escape}"><span class="glyphicon glyphicon-link" style="margin-right:7px;"></span>Developers</a>
            </div>
        </aside>
                
    <!--  MEMBERS BLOCK  -->
        <aside class="col-md-4">
            {if $Project->Memberships}
                <h3>Members</h3>

                <ul class="list-inline people-list">
                {foreach item=Membership from=$Project->Memberships}
                    {$Member = $Membership->Member}
                    <li class="listed-person {tif $Project->MaintainerID == $Member->ID ? maintainer}">
                        <a
                            href="/members/{$Member->Username}"
                            class="thumbnail member-thumbnail"
                            data-toggle="tooltip"
                            data-placement="bottom"
                            title="{$Member->FullName|escape} &mdash; {projectMemberTitle $Membership}"
                        >
                            {avatar $Member size=60}
                        </a>
                    </li>
                {foreachelse}
                    <li class="muted">{_ "None registered"}</li>
                {/foreach}
                    <li><a class="btn btn-success add-person" href="#add-member" data-toggle="modal">+ {_ "Add"}</a></li>
                </ul>
            {/if}
            <hr>
    <!-- TAGS BLOCK -->
                {if $Project->TechTags}
                    {_ "Tech"}:
                    <ul>
                    {foreach item=Tag from=$Project->TechTags}
                        <li>{contextLink $Tag}</li>
                    {/foreach}
                    </ul>
                {/if}

                {if $Project->TopicTags}
                    {_ "Topics"}:
                    <ul>
                    {foreach item=Tag from=$Project->TopicTags}
                        <li>{contextLink $Tag}</li>
                    {/foreach}
                    </ul>
                {/if}
                
                {if $Project->EventTags}
                    {_ "Events"}:
                    <ul>
                    {foreach item=Tag from=$Project->EventTags}
                        <li>{contextLink $Tag}</li>
                    {/foreach}
                    </ul>
                {/if}

            <hr>

            <div>
                <a class="btn btn-xs" href="{RemoteSystems\Twitter::getTweetIntentURL('Check out $Project->Title!', array(url = 'http://$.server.HTTP_HOST/projects/$Project->Handle'))}">{_ "Spread the word on Twitter!"}</a>
            </div>
        </aside>
    </div>

{/block}

{block js-bottom}
    {$dwoo.parent}

    <form id="add-member" class="modal fade form-horizontal" role="dialog" action="/projects/{$Project->Handle}/add-member" method="POST">
        <div class="modal-dialog">    
            <div class="modal-content">    
                <header class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h3>{_ "Add project member"}</h3>
                </header>
                <section class="modal-body">
                    <div class="form-group">
                        <label for="inputUsername" class="col-sm-2 control-label">{_ "Username"}</label>
                            <input type="text" id="inputUsername" name="username" required>
                    </div>
                    <div class="form-group">
                        <label for="inputRole" class="col-sm-2 control-label">{_ "Role"}</label>
                            <input type="text" id="inputRole" name="role" placeholder="{_ 'optional'}">
                    </div>
                </section>
                <footer class="modal-footer">
                    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">{_ "Close"}</button>
                    <button class="btn btn-primary">{_ "Add member"}</button>
                </footer>
            </div>
        </div>
    </form>

    {if $.User && ($Project->hasMember($.User) || $.Session->hasAccountLevel('Staff'))}
        <form id="post-update" class="modal fade" action="/projects/{$Project->Handle}/updates" method="POST">
            <header class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h3>{_ "Post project update"}</h3>
            </header>
            <section class="modal-body">
                <textarea class="form-control" name="Body" rows="10" required></textarea>
                <span class="help-block">{_ "Markdown is supported"}</span>
            </section>
            <footer class="modal-footer">
                <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">{_ "Close"}</button>
                <button class="btn btn-primary">{_ "Post Update"}</button>
            </footer>
        </form>
    {/if}

    {if $.Session->hasAccountLevel('Staff')}
        <div id="manage-members" class="modal fade">
            <header class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h3>{_ "Manage project members"}</h3>
            </header>
            <section class="modal-body">
                <ul class="thumbnails">
                {foreach item=Membership from=$Project->Memberships}
                    <li class="thumbnail">
                        {personLink $Membership->Member}
                        <span class="role {tif !$Membership->Role && $Membership->MemberID != $Project->MaintainerID ? muted}">{projectMemberTitle $Membership}</span>

                        <div class="btn-group">
                            {if $Membership->MemberID != $Project->MaintainerID}
                                <a href="/projects/{$Project->Handle}/change-maintainer?username={$Membership->Member->Username|escape:url}" class="btn btn-xs">{_ "Make Maintainer"}</a>
                            {/if}
                            <a href="/projects/{$Project->Handle}/remove-member?username={$Membership->Member->Username|escape:url}" class="btn btn-xs btn-danger">{_ "Remove"}</a>
                        </div>
                    </li>
                {foreachelse}
                    <li class="muted">{_ "None registered"}</li>
                {/foreach}
                </ul>
            </section>
        </div>
    {/if}

{/block}

{block js-bottom}
    {jsmin "epiceditor.js"}
    {jsmin "pages/project.js"}
{/block}
