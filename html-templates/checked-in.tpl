{extends designs/site.tpl}

{block title}How to help &mdash; {$dwoo.parent}{/block}

{block content}
    {$Checkin = $data}

    <h2>Success!</h2>
    <p>Thanks for checking in {if $Checkin->Project}to {projectLink $Checkin->Project}{/if} @ {Laddr::$siteName|escape}!</p>
    <h3>Things to do next:</h3>
    <ul>
        {if $Checkin->Project}
            <li><a href="{$Checkin->Project->getURL()}">Post an update to your project</a></li>
        {else}
            <li><a href="/projects">Find or start a project</a></li>
        {/if}

        <li><a href="/">Return to the home page</a></li>

        {if $.Session->hasAccountLevel('Developer')}
            <li><a href="/develop#/html-templates/checked-in.tpl">Add stuff to this list</a></li>
        {/if}
    </ul>
{/block}