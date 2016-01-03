{extends designs/site.tpl}

{block title}How to help &mdash; {$dwoo.parent}{/block}

{block content}
    {$Checkin = $data}

    <header class="page-header">
        <h2>{_ "Success!"}</h2>
    </header>

    <p>Thanks for checking in {if $Checkin->Project}to {projectLink $Checkin->Project}{/if} @ {Laddr::$siteName|escape}!</p>
    <h3>{_ "Things to do next:"}</h3>
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
{/block}