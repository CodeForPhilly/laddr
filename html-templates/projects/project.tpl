{extends designs/site.tpl}

{block title}{$data->Title|escape} &mdash; Projects &mdash; {$dwoo.parent}{/block}

{block content}
    {$Project = $data}

    <h2>
        {$Project->Title|escape}
        <div class="btn-group pull-right">
            <a href="/projects/{$Project->Handle}/edit" class="btn btn-info">Edit Project</a>
            {if $.User}
                <button class="btn btn-info dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
                <ul class="dropdown-menu">
                    <li><a href="#add-member" data-toggle="modal">Add Member</a></li>
                    <li><a href="/project-buzz/create?ProjectID={$Project->ID}">Log Buzz</a></li>
                    {if $.User && ($Project->hasMember($.User) || $.Session->hasAccountLevel('Staff'))}
                        <li><a href="#post-update" data-toggle="modal">Post Update</a></li>
                    {/if}
                    {if $.Session->hasAccountLevel('Staff')}
                        <li><a href="#manage-members" data-toggle="modal">Manage Members</a></li>
                    {/if}
                </ul>
            {/if}
        </div>
    </h2>

    <div class="row-fluid">
        <article class="project span8">
            <h3>Project Info</h3>
            <dl class="dl-horizontal">
                {if $Project->UsersUrl}
                    <dt>Users' URL</dt>
                    <dd><a href="{$Project->UsersUrl|escape}">{$Project->UsersUrl|escape}</a></dd>
                {/if}

                {if $Project->DevelopersUrl}
                    <dt>Developers' URL</dt>
                    <dd><a href="{$Project->DevelopersUrl|escape}">{$Project->DevelopersUrl|escape}</a></dd>
                {/if}

                {if $Project->README}
                    <dt>README</dt>
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
                Project Activity
                <div class="btn-group">
                    {if $.User && $Project->hasMember($.User)}
                        <a href="#post-update" class="btn btn-mini" data-toggle="modal">Post Update</a>
                    {/if}
                    <a href="/project-buzz/create?ProjectID={$Project->ID}" class="btn btn-mini">Log Buzz</a>
                </div>
            </h3>

            {foreach item=Article from=$Project->getActivity()}
                {projectActivity $Article headingLevel=h4 showProject=no}
            {foreachelse}
                <em>This project doesn't have any activity yet, post an update or log some buzz!</em>
            {/foreach}
        </article>

        <aside class="twitterstream span4">
            {if $Project->Memberships}
                <h3>Members</h3>

                <ul class="inline people-list">
                {foreach item=Membership from=$Project->Memberships}
                    {$Member = $Membership->Member}
                    <li class="listed-person {tif $Project->MaintainerID == $Member->ID ? maintainer}">
                        <a
                            href="/members/{$Member->Username}"
                            class="thumbnail member-thumbnail"
                            data-toggle="tooltip"
                            data-placement="bottom"
                            title="{$Member->FullName|escape}{if $Membership->Role}&mdash;{$Membership->Role}{/if}{if $Project->MaintainerID == $Member->ID}{tif $Membership->Role ? ' and ' : '&mdash;'}Maintainer{/if}"
                        >
                            {avatar $Member size=60}
                        </a>
                    </li>
                {foreachelse}
                    <li class="muted">None registered</li>
                {/foreach}
                    <li><a class="btn btn-success add-person" href="#add-member" data-toggle="modal">+ Add</a></li>
                </ul>
            {/if}

            <hr>

            <div>
                <a class="btn btn-mini" href="{RemoteSystems\Twitter::getTweetIntentURL('Check out $Project->Title!', array(url = 'http://$.server.HTTP_HOST/projects/$Project->Handle'))}">Spread the word on Twitter!</a>
            </div>
        </aside>
    </div>

{/block}

{block js-bottom}
    {$dwoo.parent}

    <form id="add-member" class="modal fade hide form-horizontal" action="/projects/{$Project->Handle}/add-member" method="POST">
        <header class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3>Add project member</h3>
        </header>
        <section class="modal-body">
            <div class="control-group">
                <label class="control-label" for="inputUsername">Username</label>
                <div class="controls">
                    <input type="text" id="inputUsername" name="username" required>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="inputRole">Role</label>
                <div class="controls">
                    <input type="text" id="inputRole" name="role" placeholder="optional">
                </div>
            </div>
        </section>
        <footer class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
            <button class="btn btn-primary">Add member</button>
        </footer>
    </form>

    {if $.User && ($Project->hasMember($.User) || $.Session->hasAccountLevel('Staff'))}
        <form id="post-update" class="modal fade hide" action="/projects/{$Project->Handle}/updates" method="POST">
            <header class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h3>Post project update</h3>
            </header>
            <section class="modal-body">
                <textarea class="input-block-level" name="Body" rows="10" required></textarea>
                <span class="help-block">Markdown is supported</span>
            </section>
            <footer class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                <button class="btn btn-primary">Post Update</button>
            </footer>
        </form>
    {/if}

    {if $.Session->hasAccountLevel('Staff')}
        <div id="manage-members" class="modal fade hide">
            <header class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h3>Manage project members</h3>
            </header>
            <section class="modal-body">
                <ul class="thumbnails">
                {foreach item=Membership from=$Project->Memberships}
                    <li class="thumbnail">
                        {personLink $Membership->Member}
                        <span class="role {tif !$Membership->Role && $Membership->MemberID != $Project->MaintainerID ? muted}">{projectMemberTitle $Membership}</span>

                        <div class="btn-group">
                            {if $Membership->MemberID != $Project->MaintainerID}
                                <a href="/projects/{$Project->Handle}/change-maintainer?username={$Membership->Member->Username|escape:url}" class="btn btn-mini">Make Maintainer</a>
                            {/if}
                            <a href="/projects/{$Project->Handle}/remove-member?username={$Membership->Member->Username|escape:url}" class="btn btn-mini btn-danger">Remove</a>
                        </div>
                    </li>
                {foreachelse}
                    <li class="muted">None registered</li>
                {/foreach}
                </ul>
            </section>
        </div>
    {/if}

    {jsmin epiceditor.js+pages/project.js}
{/block}