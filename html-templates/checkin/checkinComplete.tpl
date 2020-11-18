{extends designs/site.tpl}

{block title}{_ "Checkin Complete"} &mdash; {$dwoo.parent}{/block}

{block content}
    {$Checkin = $data}

    <div class="page-header">
        <h1>{_ "Success!"}</h1>
    </div>
    {capture assign=checkinProject}{projectLink $Checkin->Project}{/capture}
    {capture assign=checkinSiteName}{Laddr::$siteName|escape}{/capture}
      {if $Checkin->Project}
        <p>{sprintf(_("Thanks for checking in to %s @ %s!"), $checkinProject, $checkinSiteName)}</p>
      {else}
        <p>{sprintf(_("Thanks for checking in @ %s!"), $checkinSiteName)}</p>
      {/if}
    <h2>{_ "Things to do next:"}</h2>
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
