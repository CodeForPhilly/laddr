{load_templates subtemplates/personName.tpl}
{load_templates subtemplates/icon.tpl}
{load_templates subtemplates/timestamp.tpl}
{load_templates subtemplates/people.tpl}

{template projectUpdate Update headingLevel=h2 showHeading=true showProject=true articleClass=""}
    <article class="post post-update card mb-4 {$articleClass}">
        <div class="card-body">
            {if $showHeading}
                <{$headingLevel} class="post-title">
                    {if $showProject}
                        <a class="pull-right" href="{$Update->Creator->getURL()}" title="{personName $Update->Creator}" data-toggle="tooltip">{avatar $Update->Creator size=64}</a>
                        <a href="{$Update->Project->getURL()}">{$Update->Project->Title|escape}</a>
                        <small class="text-muted">{icon "asterisk"} <a href="{$Update->Project->getURL()}/updates/{$Update->Number}">{_("Update #%s")|sprintf:$Update->Number}</a></small>
                    {else}
                        <a href="{$Update->Project->getURL()}/updates/{$Update->Number}">{_("Update #%s")|sprintf:$Update->Number}</a>
                    {/if}
                </{$headingLevel}>
            {/if}

            <div class="content-markdown update-body">{$Update->Body|escape|markdown}</div>
        </div>
        <footer class="post-footer card-footer clearfix">
            {if Laddr\ProjectUpdatesRequestHandler::checkWriteAccess($Update)}
                <div class="btn-group-sm pull-right">
                    <a href="{$Update->getURL()}/edit" class="btn btn-secondary">{icon "pencil"} <span class="sr-only">{_ Edit}</span></a>
                    <a href="{$Update->getURL()}/delete" class="btn btn-danger">{icon "trash"} <span class="sr-only">{_ Delete}</span></a>
                </div>
            {/if}

            <small class="text-muted">
                {icon "user"}&nbsp;{personLink $Update->Creator}
                &emsp;
                {icon "clock-o"}&nbsp;<a href="{$Update->getURL()}">{timestamp $Update->Created}</a>
            </small>
        </footer>
    </article>
{/template}
