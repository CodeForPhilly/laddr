{extends "designs/site.tpl"}

{block "title"}GitHub Connection Status &mdash; {$dwoo.parent}{/block}

{block "content"}
    <header class="page-header">
    	<h2 class="header-title">GitHub Connection Status</h2>
	</header>

    {if $.User->hasAccountLevel('Administrator')}
    <section id="site-token">
        <h3>Site-wide system token</h3>

        {if Emergence\GitHub\API::$accessToken}
            <code>{Emergence\GitHub\API::$accessToken|escape}</code>
        {else}
            <em><code>Emergence\GitHub\API::$accessToken</code> is not currently configured</em>
        {/if}
    </section>
    {/if}

    <section id="user-token">
        <h3>Linked GitHub User</h3>

        {if $.User->GitHubToken}
            <p>Your GitHub access token is <code>{$.User->GitHubToken|escape}</code></p>
            <form action="/connectors/github/unlink-user" method="POST">
                <button type="submit" class="destructive">Clear access token and unlink GitHub user account</button>
            </form>
        {else}
            <p>You do not currently have a GitHub user account linked</p>
            <form action="/connectors/github/link-user">
                <button type="submit" class="primary">Connect your GitHub user account</button>
            </form>
        {/if}
    </section>
{/block}