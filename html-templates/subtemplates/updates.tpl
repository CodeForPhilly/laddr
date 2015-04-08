{load_templates subtemplates/timestamp.tpl}
{load_templates subtemplates/people.tpl}

{template projectUpdate Update headingLevel=h2 showHeading=true showProject=true articleClass=""}
    <article class="project-update {$articleClass}">
        {if $showHeading}
            <{$headingLevel}>
                {if Laddr\ProjectUpdatesRequestHandler::checkWriteAccess($Update)}
                    <div class="btn-group pull-right">
                        <a href="{$Update->getURL()}/edit" class="btn btn-xs">{_ Edit}</a>
                        <a href="{$Update->getURL()}/delete" class="btn btn-xs btn-warning">{_ Delete}</a>
                    </div>
                {/if}
                {if $showProject}
                    <a href="{$Update->Project->getURL()}">{$Update->Project->Title|escape}</a>
                    <small><a href="{$Update->Project->getURL()}/updates/{$Update->Number}">{_("Update #%s")|sprintf:$Update->Number}</a></small>
                {else}
                    <a href="{$Update->Project->getURL()}/updates/{$Update->Number}">{_("Update #%s")|sprintf:$Update->Number}</a>
                {/if}
            </{$headingLevel}>
        {/if}
        <div class="update-body well">
            {$Update->Body|escape|markdown}
            {capture assign=timestampCreated}{timestamp $Update->Created}{/capture}
            {capture assign=creatorLink}{personLink $Update->Creator avatar=off}{/capture}
            <p class="muted"><small>{sprintf(_("Posted on %s by %s"), $timestampCreated, $creatorLink)}</small></p>
        </div>
    </article>
{/template}