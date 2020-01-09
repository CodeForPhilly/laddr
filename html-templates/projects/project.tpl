{extends designs/site.tpl}

{block title}{$data->Title|escape} &mdash; {_ 'Projects'} &mdash; {$dwoo.parent}{/block}

{block content}
    {$Project = $data}

    <div class="page-header">
        <div class="btn-toolbar pull-right">
            <div class="btn-group">
                <a href="/projects/{$Project->Handle}/edit" class="btn btn-info">{_ "Edit Project"}</a>
                {if $.User}
                    <button class="btn btn-info dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="#add-member" data-toggle="modal">{_ "Add Member"}</a>
                        <a class="dropdown-item" href="/project-buzz/create?ProjectID={$Project->ID}">{_ "Log Buzz"}</a>
                        {if $.User && ($Project->hasMember($.User) || $.Session->hasAccountLevel('Staff'))}
                            <a class="dropdown-item" href="#post-update" data-toggle="modal">{_ "Post Update"}</a>
                        {/if}
                        {if $.Session->hasAccountLevel('Staff')}
                            <a class="dropdown-item" href="#manage-members" data-toggle="modal">{_ "Manage Members"}</a>
                        {/if}
                    </div>
                {/if}
            </div>
        </div>

        <h1>{$Project->Title|escape}</h1>
    </div>

    <div class="row">
        <div class="col-md-8">
            {if $Project->Stage}
                <h2>{_ "Stage"}</h2>
                {if $Project->Stage == null}
                <span class="badge badge-info" data-toggle="tooltip" data-placement="bottom" title="{Laddr\Project::getStageDescription($Project->Stage)}">{$Project->Stage}</span>
                {/if}
                {if $Project->Stage == Commenting}
                <div class="progress">
                    <div class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100" style="width: 10%;" data-toggle="tooltip" title="{Laddr\Project::getStageDescription(Hibernating)|escape}">
                    <span class="show">{$Project->Stage}</span>
                    </div>
                </div>
                {/if}
                {if $Project->Stage == Bootstrapping}
                <div class="progress">
                    <div class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100" style="width: 30%;" data-toggle="tooltip" title="{Laddr\Project::getStageDescription(Bootstrapping)|escape}">
                    <span class="show">{$Project->Stage}</span>
                    </div>
                </div>
                {/if}
                {if $Project->Stage == Prototyping}
                <div class="progress">
                    <div class="progress-bar progress-bar-info progress-bar-striped" role="progressbar" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100" style="width: 70%;" data-toggle="tooltip" title="{Laddr\Project::getStageDescription(Prototyping)|escape}">
                    {$Project->Stage}
                    </div>
                </div>
                {/if}
                {if $Project->Stage == Testing}
                <div class="progress">
                    <div class="progress-bar progress-bar-info progress-bar-striped" role="progressbar" aria-valuenow="90" aria-valuemin="0" aria-valuemax="100" style="width: 90%;" data-toggle="tooltip" title="{Laddr\Project::getStageDescription(Testing)|escape}">
                    {$Project->Stage}
                    </div>
                </div>
                {/if}
                {if $Project->Stage == Maintaining}
                <div class="progress">
                    <div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%;" data-toggle="tooltip" title="{Laddr\Project::getStageDescription(Maintaining)|escape}">
                    {$Project->Stage}
                    </div>
                </div>
                {/if}
                {if $Project->Stage == Drifting}
                <div class="progress">
                    <div class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%;" data-toggle="tooltip" title="{Laddr\Project::getStageDescription(Drifting)|escape}">
                    <span class="show">{$Project->Stage}</span>
                    </div>
                </div>
                {/if}
                {if $Project->Stage == Hibernating}
                <div class="progress">
                    <div class="progress-bar progress-bar-danger progress-bar-striped" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%;" data-toggle="tooltip" title="{Laddr\Project::getStageDescription(Hibernating)|escape}">
                    {$Project->Stage}
                    </div>
                </div>
                {/if}
            {/if}
            {if $Project->README}
                <h2>{_ "README"}</h2>
                <div class="content-readme content-markdown well">
                    {$Project->README|escape|markdown}
                </div>
            {/if}

            {*
            <h2>Comments:</h2>
            <form method="post" action="/projects/{$Project->Handle}/comment">
                <textarea name="Message"></textarea>
                <input type="submit" value="Submit">
            </form>
            {foreach item=Comment from=$Project->$Comments}
                <p>
                {$Comment->Message}
                </p>
            {/foreach}
            *}

            {* if ($.User && $Project->hasMember($.User))}
                <form action="/projects/{$Project->Handle}/json/create-request">
                    <button class="btn btn-success" type="submit">{_ 'Need Help?'}&hellip;</button>
                </form>
            {/if *}

            <h2>
                {_ "Project Activity"}
                <div class="btn-group pull-right">
                    {if $.User && $Project->hasMember($.User)}
                        <a href="#post-update" class="btn btn-primary btn-sm" data-toggle="modal">{_ "Post Update"}</a>
                    {/if}
                    <a href="/project-buzz/create?ProjectID={$Project->ID}" class="btn btn-success btn-sm">{_ "Log Buzz"}</a>
                </div>
            </h2>

            {foreach item=Article from=$Project->getActivity()}
                {projectActivity $Article headingLevel=h3 showProject=no}
            {foreachelse}
                <em>{_ "This project doesn't have any activity yet, post an update or log some buzz!"}</em>
            {/foreach}
        </div>

        <!--  PROJECT INFO  -->
        <div class="col-md-4">
            <h2>{_ "Project Info"}</h2>

            <!--  PROJECT LINKS  -->
            <div role="group" aria-label="...">
                {if $Project->UsersUrl}
                    <a class="btn btn-primary btn-block" role="button" href="{$Project->UsersUrl|escape}">
                        {icon "user"}&nbsp;{_ "Users' Site"}
                        <div class="small">{$Project->UsersUrl|escape}</div>
                    </a>
                {/if}
                {if $Project->DevelopersUrl}
                    <a class="btn btn-success btn-block" role="button" href="{$Project->DevelopersUrl|escape}">
                        {icon "cog"}&nbsp;{_ "Developers' Site"}
                        <div class="small">{$Project->DevelopersUrl|escape}</div>
                    </a>
                {/if}
                {if $Project->ChatChannel}
                    {if Laddr::$chatLinker}
                        <a class="btn btn-success btn-block" role="button" href="{call_user_func(Laddr::$chatLinker, $Project->ChatChannel)|escape}" target="_blank">
                            {icon "comment"}&nbsp;{_ "Chat Channel"}
                            <div class="small">#{$Project->ChatChannel|escape}</div>
                        </a>
                    {else}
                        <p class="text-center">Chat Channel: <strong>#{$Project->ChatChannel|escape}</strong></p>
                    {/if}
                {/if}
            </div>

            <!--  MEMBERS BLOCK  -->
            {if $Project->Memberships}
                <h3>{_ "Members"}</h3>

                <ul class="list-inline people-list">
                {foreach item=Membership from=$Project->Memberships}
                    {$Member = $Membership->Member}
                    <li class="list-inline-item people-list-person {tif $Project->MaintainerID == $Member->ID ? maintainer}">
                        <a
                            href="/members/{$Member->Username}"
                            class="member-thumbnail"
                            data-toggle="tooltip"
                            data-placement="bottom"
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
                    <li class="muted list-inline-item">{_ "No registered members"}</li>
                {/foreach}
                </ul>
                <a class="btn btn-success add-person" href="#add-member" data-toggle="modal">+ {_ "Add"}</a>
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
                <a href="{RemoteSystems\Twitter::getTweetIntentURL('Check out $Project->Title!', array(url = 'http://$.server.HTTP_HOST/projects/$Project->Handle'))}"><img src="{versioned_url img/icon-twitter.svg}" alt="{_ 'Spread the word on Twitter!'}" title="{_ 'Spread the word on Twitter!'}"/></a>
            </div>
        </div>
    </div>

{/block}

{block js-bottom}
    {$dwoo.parent}

    <form id="add-member" class="modal fade form-horizontal" tabindex="-1" role="dialog" aria-labelledby="add-member-title" action="/projects/{$Project->Handle}/add-member" method="POST">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                    <h2 id="add-member-title" class="modal-title">{_ "Add project member"}</h2>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="inputUsername" class="col-sm-2 control-label">{_ "Username"}</label>
                        <div class="col-sm-10">
                            <input type="text" id="inputUsername" class="form-control" name="username" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputRole" class="col-sm-2 control-label">{_ "Role"}</label>
                        <div class="col-sm-10">
                            <input type="text" id="inputRole" class="form-control" name="role" placeholder="{_ 'optional'}">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary">{_ "Add member"}</button>
                </div>
            </div>
        </div>
    </form>

    {if $.User && ($Project->hasMember($.User) || $.Session->hasAccountLevel('Staff'))}
    <form id="post-update" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="project-update-title" action="/projects/{$Project->Handle}/updates" method="POST">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                    <h2 id="project-update-title" class="modal-title">{_ "Post project update"}</h2>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <textarea class="form-control" name="Body" rows="10" required></textarea>
                        <span class="help-block">{_ "Markdown is supported"}</span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary">{_ "Post Update"}</button>
                </div>
            </div>
        </div>
    </form>
    {/if}

    {if $.Session->hasAccountLevel('Staff')}
        <div id="manage-members" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="manage-members-title">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                        <h2 id="manage-members-title" class="modal-title">{_ "Manage project members"}</h2>
                    </div>
                    <div class="modal-body">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>{_ Member}</th>
                                    <th>{_ Role}</th>
                                    <th><span class="sr-only">{_ "Make Member a Maintainer"}</span></th>
                                    <th><span class="sr-only">{_ "Remove Member"}</span></th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach item=Membership from=$Project->Memberships}
                                    <tr>
                                        <td>{personLink $Membership->Member}</td>
                                        <td>{projectMemberTitle $Membership}</td>
                                        <td>
                                            {if $Membership->MemberID != $Project->MaintainerID}
                                                <a href="/projects/{$Project->Handle}/change-maintainer?username={$Membership->Member->Username|escape:url}" class="btn btn-sm btn-primary">{_ "Make Maintainer"}</a>
                                            {/if}
                                        </td>
                                        <td>
                                            <a href="/projects/{$Project->Handle}/remove-member?username={$Membership->Member->Username|escape:url}" class="btn btn-sm btn-danger">{_ "Remove"}</a>
                                        </td>
                                    </tr>
                                {foreachelse}
                                    <tr>
                                        <td class="muted" colspan="4">{_ "None registered"}</td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    {/if}

    {jsmin "lib/epiceditor.js"}
    {jsmin "pages/project.js"}
{/block}
