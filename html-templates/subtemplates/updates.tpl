{load_templates subtemplates/timestamp.tpl}
{load_templates subtemplates/people.tpl}

{template projectUpdate Update headingLevel=h2 showHeading=true showProject=true articleClass=""}
    <article class="project-update {$articleClass}">
        {if $showHeading}
            <{$headingLevel}>
                {if Laddr\ProjectUpdatesRequestHandler::checkWriteAccess($Update)}
                    <div class="btn-group pull-right">
                        <a href="{$Update->getURL()}/edit" class="btn btn-mini">Edit</a>
                        <a href="{$Update->getURL()}/delete" class="btn btn-mini btn-warning">Delete</a>
                    </div>
                {/if}
                {if $showProject}
                    <a href="{$Update->Project->getURL()}">{$Update->Project->Title|escape}</a>
                    <small><a href="{$Update->Project->getURL()}/updates/{$Update->Number}">Update #{$Update->Number}</a></small>
                {else}
                    <a href="{$Update->Project->getURL()}/updates/{$Update->Number}">Update #{$Update->Number}</a>
                {/if}
            </{$headingLevel}>
        {/if}
        <div class="update-body well">
            {$Update->Body|escape|markdown}
            <p class="muted"><small>Posted on {timestamp $Update->Created} by {personLink $Update->Creator avatar=off}</small></p>
        </div>
    </article>
{/template}