{extends "designs/site.tpl"}

{block title}{_ "Registration complete"} &mdash; {$dwoo.parent}{/block}

{block "content"}
    {$User = $data}

    <header class="page-header">
        <h2>{_ "Registration complete"}</h2>
    </header>

    {capture assign=personLink}<a href="{$User->getUrl()|escape}">{$User->Username|escape}</a>{/capture}
    <p class="lead">{"Your username for %s is: %s"|_|sprintf:Laddr::$siteName:$personLink}</p>

    <p>
        {_ "Things to do next…"}
        <ul>
            {if $.request.return}
                <li><a href="{$.request.return|escape}">{"Continue back to %s"|_|sprintf:$.request.return|escape}</a></li>
            {/if}
            <li><a href="/profile">{_ "Fill out your profile and upload a photo"}</a></li>
            <li>Take <a href="https://codeforphilly.typeform.com/to/UnDAvy" target="_blank">this short survey</a> to let us know about your experience so far.</li>
        </ul>
    </p>

    <p><em>
        Photos taken during Code for Philly events and meetups may be used for promotional purposes. By attending a Code for Philly event,
        you grant Code for Philly the right to use the photographs or their likenesses in Code for Philly publications, video, websites,
        news media, social media, or other recruitment or promotional materials. Should you have any objection to the use of your photograph,
        please see a staff member or contact us at <a href="mailto:hello@codeforphilly.org?subject=Photography">hello@codeforphilly.org</a>.
    </em></p>
{/block}