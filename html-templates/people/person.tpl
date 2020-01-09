{extends "designs/site.tpl"}

{block "title"}{personName $data} &mdash; {$dwoo.parent}{/block}


{block "content"}
    {$Person = $data}

    <div class="page-header">
        {if $.User->ID == $Person->ID || (ProfileRequestHandler::$accountLevelEditOthers && $.User->hasAccountLevel(ProfileRequestHandler::$accountLevelEditOthers))}
            <div class="btn-toolbar pull-right margin-bottom margin-left">
                <div class="btn-group">
                    <a class="btn btn-primary" href="/profile{tif $.User->ID != $Person->ID ? cat('?person=', $Person->ID)}">{_ "Edit Profile"}</a>
                    {if $.User->hasAccountLevel('Staff')}
                        {capture assign=deletePersonName}{personName $Person}{/capture}
                        <a class="btn btn-danger" href="{$Person->getUrl('/delete')|escape}">{sprintf(_("Delete %s"), $deletePersonName)}</a>
                    {/if}
                </div>
            </div>
        {/if}

        <h1>{personName $Person}</h1>
        {if $Person->Location}
            <p><a href="http://maps.google.com/?q={$Person->Location|escape:url}" target="_blank">{$Person->Location|escape}</a></p>
        {/if}
    </div>

    <div class="row">
        <div id="photos" class="col-sm-3">
            <div class="text-center">
                {avatar $Person size=200 imgCls="img-responsive"}
                <div id="photo-thumbs" class="clearfix">
                    {foreach item=Photo from=$Person->Photos}
                        <a href="{$Photo->getThumbnailRequest(1024,768)}" class="photo-thumb" id="t{$Photo->ID}" title="{$Photo->Caption|escape}"><img src="{$Photo->getThumbnailRequest(48,48)}" /></a>
                    {/foreach}
                </div>
            </div>
        </div>

        <div id="info" class="col-sm-9">
            {if $Person->About}
                <h2 class="h3">{_ 'About Me'}</h2>
                <section class="about content-markdown">
                    {$Person->About|escape|markdown}
                </section>
            {/if}

            {if $.User}
                <h2 class="h3">{_ 'Contact Information'}</h2>
                <dl class="section">
                    {if $Person->Email}
                        <dt>{_ Email}</dt>
                        <dd><a href="mailto:{$Person->Email}" title="Email {personName $Person}">{$Person->Email}</a></dd>
                    {/if}

                    {if $Person->Twitter}
                        <dt>{_ Twitter}</dt>
                        <dd><a href="https://twitter.com/{$Person->Twitter|escape}">{$Person->Twitter|escape}</a></dd>
                    {/if}

                    {if $Person->Phone}
                        <dt>{_ Phone}</dt>
                        <dd><a href="tel:{$Person->Phone|escape:url}">{$Person->Phone|phone}</a></dd>
                    {/if}
                </dl>
            {/if}

            {if $Person->TechTags}
                <h2 class="h3">{_ "Tech I'm interested in"}</h2>
                <ul>
                {foreach item=Tag from=$Person->TechTags}
                    <li>{contextLink $Tag}</li>
                {/foreach}
                </ul>
            {/if}

            {if $Person->TopicTags}
                <h2 class="h3">{_ "Topics I'm interested in"}</h2>
                <ul>
                {foreach item=Tag from=$Person->TopicTags}
                    <li>{contextLink $Tag}</li>
                {/foreach}
                </ul>
            {/if}

            {if $Person->ProjectMemberships}
                <h2 class="h3">{_ 'My projects'}</h2>
                <ul>
                {foreach item=Membership from=$Person->ProjectMemberships}
                    <li>{projectLink $Membership->Project} &mdash; {projectMemberTitle $Membership}</li>
                {/foreach}
                </ul>
            {/if}

            {if $Person->LastCheckin}
                <h2 class="h3">{_ "Last event checkin"}</h2>
                <a href="{RemoteSystems\Meetup::getEventUrl($Person->LastCheckin->MeetupID)}">{$Person->LastCheckin->Created|date_format:'%c'}</a>
            {/if}
        </div>

    </div>
{/block}
