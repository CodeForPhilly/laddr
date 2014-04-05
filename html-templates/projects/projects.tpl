{extends designs/site.tpl}

{block title}Projects &mdash; {$dwoo.parent}{/block}

{block content}
    <div class="page-header">
        <h2>Civic Projects Directory</h2>
        {if $.User}
            <form action="/projects/create">
                <button class="btn btn-success" type="submit">Add Project&hellip;</button>
            </form>
        {else}
            <a href="/register" class="btn btn-danger">Register with the Brigade!</a>
        {/if}
    </div>

    {foreach item=Project from=$data}
        <div class="row-fluid">
            <div class="span8">
                <h3>
                    <a name="{$Project->Handle}" href="{$Project->getURL()}">{$Project->Title|escape}</a>
                </h3>

                <div class="well">
                    {if $Project->README}
                        <div class="markdown readme">{$Project->README|escape|markdown}</div>
                    {/if}
                    {if $Project->UsersUrl}
                        For Users: <a href="{$Project->UsersUrl|escape}">{$Project->UsersUrl|escape}</a>
                        <br/>
                    {/if}
                    {if $Project->DevelopersUrl}
                        For Developers: <a href="{$Project->DevelopersUrl|escape}">{$Project->DevelopersUrl|escape}</a>
                    {/if}
                </div>
            </div>

            {if $Project->Memberships}
            <div class="span4">
                <h3><small>Members</small></h3>

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
                </ul>
            </div>
            {/if}
        </div> <!-- .row-fluid -->
        <hr>
    {/foreach}
{/block}