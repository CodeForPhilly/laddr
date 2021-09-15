{extends "designs/site.tpl"}

{block "title"}Slack Connection Status &mdash; {$dwoo.parent}{/block}

{block "content"}
    <header class="page-header">
        <h2 class="header-title">Slack Connection Status</h2>
	</header>

    {if $.User->hasAccountLevel('Administrator')}
    <section id="configuration">
        <h3>Configuration</h3>

        <h4>Slack Team</h4>
        <dl>
            <dt><code>Emergence\Slack\Connector::$teamHost</code></dt>
            <dd>
                {if Emergence\Slack\Connector::$teamHost}
                    <q>{Emergence\Slack\Connector::$teamHost|escape}</q>
                {else}
                    <em>Not configured</em>
                {/if}
            </dd>
        </dl>

        <h4>Slack Application</h4>
        <p>Create an app at <a href="https://api.slack.com/apps">https://api.slack.com/apps</a>
        <dl>
            <dt><code>Emergence\Slack\API::$clientId</code></dt>
            <dd>
                {if Emergence\Slack\API::$clientId}
                    <q>{Emergence\Slack\API::$clientId|escape}</q>
                {else}
                    <em>Not configured</em>
                {/if}
            </dd>

            <dt><code>Emergence\Slack\API::$clientSecret</code></dt>
            <dd>
                {if Emergence\Slack\API::$clientSecret}
                    <q>{Emergence\Slack\API::$clientSecret|escape}</q>
                {else}
                    <em>Not configured</em>
                {/if}
            </dd>

            <dt><code>Emergence\Slack\API::$verificationToken</code></dt>
            <dd>
                {if Emergence\Slack\API::$verificationToken}
                    <q>{Emergence\Slack\API::$verificationToken|escape}</q>
                {else}
                    <em>Not configured</em>
                {/if}
            </dd>

            <dt><code>Emergence\Slack\API::$accessToken</code></dt>
            <dd>
                {if Emergence\Slack\API::$accessToken}
                    <q>{Emergence\Slack\API::$accessToken|escape}</q>
                {else}
                    <em>Not configured</em>
                {/if}
            </dd>
        </dl>

        <h5>Enabling Events</h5>
        <ol>
            <li>Visit the <strong>Event Subscriptions</strong> section while managing the application</li>
            <li>Set <strong>Request URL</strong> to <a href="{Emergence\Slack\Connector::getBaseUrl(true)}/webhooks">{Emergence\Slack\Connector::getBaseUrl(true)}/webhooks</a></li>
            <li>Add all desired team events</li>
            <li>Visit the <strong>Install App</strong> section while managing the application and follow the process to install the app to your team</li>
            <li>Configure <code>Emergence\Slack\API::$accessToken</code> with the provided access token</li>
        </ol>

        <h4>Send test message</h4>
        <form method="POST" action="/connectors/slack/test">
            {field inputName="channel" label="Channel" default='bot-debug'}
            {textarea inputName="message" label="Channel" default=':waving: Hello Slack!'}

            <div class="submit-area">
                <button class="submit" type="submit">Send Message</button>
            </div>
        </form>
    </section>
    {/if}

    <section id="team">
        <h3>Slack Team</h3>

        {if Emergence\Slack\Connector::$teamHost}
            <a href="/connectors/slack/launch" class="button">Launch {Emergence\Slack\Connector::$teamHost|escape}</a>
        {else}
            <em>No Slack team has been configured yet</em>
        {/if}
    </section>
{/block}