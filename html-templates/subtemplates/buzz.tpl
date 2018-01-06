{load_templates subtemplates/personName.tpl}
{load_templates subtemplates/glyphicons.tpl}
{load_templates subtemplates/timestamp.tpl}
{load_templates subtemplates/people.tpl}

{template projectBuzz Buzz headingLevel=h2 showHeading=true showProject=true articleClass=""}
    <article class="post post-buzz card mb-4 {$articleClass}">
        <div class="card-body">
            <header class="post-header">
                {if $showHeading && $showProject}
                    <{$headingLevel} class="post-title">
                        <a class="pull-right" href="{$Buzz->Creator->getURL()}" title="{personName $Buzz->Creator}" data-toggle="tooltip">{avatar $Buzz->Creator size=64}</a>
                        <a href="{$Buzz->Project->getURL()}">{$Buzz->Project->Title|escape}</a>
                        <small class="text-muted">{glyph "flash"} Buzz</small>
                    </{$headingLevel}>
                {/if}
                <p class="post-subtitle"><a href="{$Buzz->getURL()}">{$Buzz->Headline|escape}</a></p>
            </header>

            <div class="post-summary content-markdown">{$Buzz->Summary|markdown}</div>

            {if $Buzz->Image}
                <blockquote><a href="{$Buzz->URL|escape}"><img class="img-responsive img-rounded" src="{$Buzz->Image->getThumbnailRequest(300, 300)}"></a></blockquote>
            {/if}

            <a class="btn btn-info" href="{$Buzz->URL|escape}">{sprintf(_("Read the full article on %s"), parse_url($Buzz->URL, $.const.PHP_URL_HOST))}&hellip;</a>
            &ensp;
            <small class="text-muted">{_ "Published"} {timestamp $Buzz->Published}</small>
        </div>
        <footer class="post-footer card-footer">
            {capture assign=timestampCreated}{glyph "time"}&nbsp;<a href="{$Buzz->getURL()}">{timestamp $Buzz->Created}</a>{/capture}
            {capture assign=creatorLink}{glyph "user"}&nbsp;{personLink $Buzz->Creator}{/capture}

            {if Laddr\ProjectBuzzRequestHandler::checkWriteAccess($Buzz)}
                <div class="btn-group pull-right">
                    <a href="{$Buzz->getURL()}/edit" class="btn btn-sm btn-secondary">{glyph "pencil"} <span class="sr-only">{_ Edit}</span></a>
                    <a href="{$Buzz->getURL()}/delete" class="btn btn-sm btn-danger">{glyph "trash"} <span class="sr-only">{_ Delete}</span></a>
                </div>
            {/if}

            <small class="text-muted">{sprintf(_("%s &emsp; %s"), $creatorLink, $timestampCreated)}</small>
        </footer>
    </article>
{/template}
