{load_templates subtemplates/glyphicons.tpl}
{load_templates subtemplates/timestamp.tpl}
{load_templates subtemplates/people.tpl}

{template projectUpdate Update headingLevel=h2 showHeading=true showProject=true articleClass=""}
    <article class="project-update {$articleClass} panel panel-default">
        <div class="update-body panel-body">
            {if $showHeading}
                <{$headingLevel}>
                    {if $showProject}
                        <a class="pull-right" href="{$Update->Creator->getURL()}" title="{$Update->Creator->FullName}" data-toggle="tooltip">{avatar $Update->Creator size=64}</a>
                        <a href="{$Update->Project->getURL()}">{$Update->Project->Title|escape}</a>
                        <small class="text-muted">{glyph "asterisk"} <a href="{$Update->Project->getURL()}/updates/{$Update->Number}">{_("Update #%s")|sprintf:$Update->Number}</a></small>
                    {else}
                        <a href="{$Update->Project->getURL()}/updates/{$Update->Number}">{_("Update #%s")|sprintf:$Update->Number}</a>
                    {/if}
                </{$headingLevel}>
            {/if}

            {$Update->Body|escape|markdown}
        </div>
        <div class="update-footer panel-footer clearfix">
            {capture assign=timestampCreated}{glyph "time"}&nbsp;<a href="{$Update->getURL()}">{timestamp $Update->Created}</a>{/capture}
            {capture assign=creatorLink}{glyph "user"}&nbsp;{personLink $Update->Creator}{/capture}

            {if Laddr\ProjectUpdatesRequestHandler::checkWriteAccess($Update)}
                <div class="btn-group pull-right">
                    <a href="{$Update->getURL()}/edit" class="btn btn-xs btn-default">{glyph "pencil"} <span class="sr-only">{_ Edit}</span></a>
                    <a href="{$Update->getURL()}/delete" class="btn btn-xs btn-danger">{glyph "trash"} <span class="sr-only">{_ Delete}</span></a>
                </div>
            {/if}

            <small class="text-muted">{sprintf(_("%s &emsp; %s"), $creatorLink, $timestampCreated)}</small>
        </div>
    </article>
{/template}