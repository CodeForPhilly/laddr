{extends "designs/site.tpl"}

{block "title"}{$data->FullNamePossessive} Profile &mdash; {$dwoo.parent}{/block}


{block "content"}
    {$Person = $data}

    <article class="member-profile">
        {avatar $Person size=200}
        <h2 class="run-in">{$Person->FullName|escape} {if $.User && $Person->ID == $.User->ID}<a href="/profile">edit your profile</a>{/if}</h2>

        {if $Person->Location}
            <p class="location"><a href="http://maps.google.com/?q={$Person->Location|escape}" target="_blank">{$Person->Location|escape}</a></p>
        {/if}

        <h3>Last event checkin</h3>
        {if $Person->LastCheckin}
            <a href="{RemoteSystems\Meetup::getEventUrl($Person->LastCheckin->MeetupID)}">{$Person->LastCheckin->Created|date_format:'%c'}</a>
        {else}
            <p>Never</p>
        {/if}

        {if $Person->About}
            <h3>About Me</h3>
            <section class="about">
                {$Person->About|escape|markdown}
            </section>
        {/if}

        {* Only logged-in users can view contact information *}
        {if $.User}
            <h3>Contact Information</h3>
            <dl>
                {if $Person->Email}
                    <dt>Email</dt>
                    <dd><a href="mailto:{$Person->EmailRecipient|escape:url}" title="Email {$Person->FullName|escape}">{$Person->Email|escape}</a></dd>
                {/if}

                {if $Person->Twitter}
                    <dt>Twitter</dt>
                    <dd><a href="https://twitter.com/{$Person->Twitter|escape}">{$Person->Twitter|escape}</a></dd>
                {/if}

                {if $Person->Phone}
                    <dt>Phone</dt>
                    <dd><a href="tel:{$Person->Phone}" target="_blank">{$Person->Phone|phone}</a></dd>
                {/if}
            </dl>

            {if $Person->ProjectMemberships}
                <dt> My projects </dt>
                {foreach item=Membership from=$Person->ProjectMemberships}
                    <li><a href="{$Membership->Project->getURL()}">{$Membership->Project->Title|escape}</a> &mdash; {projectMemberTitle $Membership}</li>
                {/foreach}
            {/if}
        {/if}
    </article>

{/block}