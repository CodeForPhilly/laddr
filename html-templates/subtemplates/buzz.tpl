{load_templates subtemplates/glyphicons.tpl}
{load_templates subtemplates/timestamp.tpl}
{load_templates subtemplates/people.tpl}

{template projectBuzz Buzz headingLevel=h2 showHeading=true showProject=true articleClass=""}
    <article class="project-buzz panel panel-default {$articleClass}">
        <div class="panel-body">
            {if $showHeading && $showProject}
                <{$headingLevel}>
                    <a class="pull-right" href="{$Buzz->Creator->getURL()}" title="{$Buzz->Creator->FullName}" data-toggle="tooltip">{avatar $Buzz->Creator size=64}</a>
                    <a href="{$Buzz->Project->getURL()}">{$Buzz->Project->Title|escape}</a>
                    <small class="text-muted">{glyph "flash"} Buzz</small>
                </{$headingLevel}>
            {/if}

            <div class="buzz-headline"><a href="{$Buzz->getURL()}">{$Buzz->Headline|escape}</a></div>

            <div class="buzz-summary">{$Buzz->Summary|markdown}</div>

            {if $Buzz->Image}
                <blockquote><a href="{$Buzz->URL|escape}"><img class="img-responsive img-rounded" src="{$Buzz->Image->getThumbnailRequest(300, 300)}"></a></blockquote>
            {/if}

            <a class="btn btn-info" href="{$Buzz->URL|escape}">{sprintf(_("Read the full article on %s"), parse_url($Buzz->URL, $.const.PHP_URL_HOST))}&hellip;</a>
            &ensp;
            <small class="text-muted">{_ "Published"} {timestamp $Buzz->Published}</small>
        </div>
        <div class="panel-footer">
            {capture assign=timestampCreated}{glyph "time"}&nbsp;<a href="{$Buzz->getURL()}">{timestamp $Buzz->Created}</a>{/capture}
            {capture assign=creatorLink}{glyph "user"}&nbsp;{personLink $Buzz->Creator}{/capture}

            {if Laddr\ProjectBuzzRequestHandler::checkWriteAccess($Buzz)}
                <div class="btn-group pull-right">
                    <a href="{$Buzz->getURL()}/edit" class="btn btn-xs btn-default">{glyph "pencil"} <span class="sr-only">{_ Edit}</span></a>
                    <a href="{$Buzz->getURL()}/delete" class="btn btn-xs btn-danger">{glyph "trash"} <span class="sr-only">{_ Delete}</span></a>
                </div>
            {/if}

            <small class="text-muted">{sprintf(_("%s &emsp; %s"), $creatorLink, $timestampCreated)}</small>
        </div>
    </article>
{/template}