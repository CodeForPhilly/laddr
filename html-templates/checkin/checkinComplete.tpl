{extends designs/site.tpl}

{block title}How to help &mdash; {$dwoo.parent}{/block}

{block content}
    {$Checkin = $data}

    <header class="page-header">
        <h2>{_ "Success!"}</h2>
    </header>

    <p>Thanks for checking in {if $Checkin->Project}to {projectLink $Checkin->Project}{/if} @ {Laddr::$siteName|escape}!</p>
    <h3>{_ "Things to do next:"}</h3>
    <p>Giving us your feedback about this experience helps us make Code for Philly better. Please take <a href="https://codeforphilly.typeform.com/to/cYwSLW">this</a> short survey.</p>
    <p class="text-center"><a href="https://codeforphilly.typeform.com/to/dLXQl5" class="btn btn-lg btn-primary" target="_blank">Take Survey</a></p>
    <ul>
        {if $Checkin->Project}
            <li><a href="{$Checkin->Project->getURL()}">{_ "Post an update to your project"}</a></li>
        {else}
            <li><a href="/projects">{_ "Find or start a project"}</a></li>
        {/if}

        <li><a href="/">{_ "Return to the home page"}</a></li>

        {if $.Session->hasAccountLevel('Developer')}
            <li><a href="/develop#/html-templates/checked-in.tpl">{_ "Add stuff to this list"}</a></li>
        {/if}
    </ul>
    <p><em>
        Photos taken during Code for Philly events and meetups may be used for promotional purposes. By attending a Code for Philly event,
        you grant Code for Philly the right to use the photographs or their likenesses in Code for Philly publications, video, websites,
        news media, social media, or other recruitment or promotional materials. Should you have any objection to the use of your photograph,
        please see a staff member or contact us at <a href="mailto:hello@codeforphilly.org?subject=Photography">hello@codeforphilly.org</a>.
    </em></p>
{/block}