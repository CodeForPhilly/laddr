{extends "designs/site.tpl"}

{block "title"}{personName $data} &mdash; {$dwoo.parent}{/block}


{block "content"}
    {$Person = $data}

    <header class="page-header">
        <h1 class="header-title title-1">{personName $Person}</h1>
        {if $Person->Location}
            <h2 class="header-details"><a href="http://maps.google.com/?q={$Person->Location|escape:url}" target="_blank">{$Person->Location|escape}</a></h2>
        {/if}
        <div class="header-buttons pull-right">
            {if $.User->ID == $Person->ID || (ProfileRequestHandler::$accountLevelEditOthers && $.User->hasAccountLevel(ProfileRequestHandler::$accountLevelEditOthers))}
                <a class="btn" href="/profile{tif $.User->ID != $Person->ID ? cat('?person=', $Person->ID)}">Edit Profile</a>
            {/if}
        </div>
    </header>

    <div id="photos">
        {avatar $Person size=200}
        <div id="photo-thumbs" class="clearfix">
            {foreach item=Photo from=$Person->Photos}
                <a href="{$Photo->getThumbnailRequest(1024,768)}" class="photo-thumb" id="t{$Photo->ID}" title="{$Photo->Caption|escape}"><img src="{$Photo->getThumbnailRequest(48,48)}" /></a>
            {/foreach}
        </div>
    </div>

    <div id="page-intro" class="">
        <h2 class="run-in"></h2>
    </div>

    <div id="info" class="">

        {if $Person->About}
            <h3>{_ 'About Me'}</h3>
            <section class="about">
                {$Person->About|escape|markdown}
            </section>
        {/if}

        {if $.User}
            <h3>{_ 'Contact Information'}</h3>
            <dl class="section">
                {if $Person->Email}
                    <dt>Email</dt>
                    <dd><a href="mailto:{$Person->Email}" title="Email {personName $Person}">{$Person->Email}</a></dd>
                {/if}

                {if $Person->Twitter}
                    <dt>Twitter</dt>
                    <dd><a href="https://twitter.com/{$Person->Twitter|escape}">{$Person->Twitter|escape}</a></dd>
                {/if}

                {if $Person->Phone}
                    <dt>Phone</dt>
                    <dd><a href="tel:{$Person->Phone|escape:url}">{$Person->Phone|phone}</a></dd>
                {/if}
            </dl>
        {/if}

        {if $Person->ProjectMemberships}
            <h3>{_ 'My projects'}</h3>
            <ul>
            {foreach item=Membership from=$Person->ProjectMemberships}
                <li>{projectLink $Membership->Project} &mdash; {projectMemberTitle $Membership}</li>
            {/foreach}
            </ul>
        {/if}

        {if $Person->LastCheckin}
            <h3>{_ "Last event checkin"}</h3>
            <a href="{RemoteSystems\Meetup::getEventUrl($Person->LastCheckin->MeetupID)}">{$Person->LastCheckin->Created|date_format:'%c'}</a>
        {/if}
    </div>
{/block}