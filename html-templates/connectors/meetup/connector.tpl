{extends "designs/site.tpl"}

{block "title"}Meetup Connection Status &mdash; {$dwoo.parent}{/block}

{block "content"}
    <header class="page-header">
    	<h2 class="header-title">Meetup Connection Status</h2>
	</header>

    {if $.User->hasAccountLevel('Administrator')}
    <section id="site-token">
        <h3>Site-wide system token</h3>

        {if Emergence\Meetup\API::$accessToken}
            <code>{Emergence\Meetup\API::$accessToken|escape}</code>
        {else}
            <em><code>Emergence\Meetup\API::$accessToken</code> is not currently configured</em>
        {/if}
    </section>
    {/if}

    <section id="user-token">
        <h3>Linked Meetup User</h3>

        {if $.User->MeetupToken}
            <p>Your Meetup access token is <code>{$.User->MeetupToken|escape}</code></p>
            <form action="/connectors/meetup/unlink-user" method="POST">
                <button type="submit" class="destructive">Clear access token and unlink Meetup user account</button>
            </form>
        {else}
            <p>You do not currently have a Meetup user account linked</p>
            <form action="/connectors/meetup/link-user">
                <button type="submit" class="primary">Connect your Meetup user account</button>
            </form>
        {/if}
    </section>
{/block}