{load_templates subtemplates/personName.tpl}
{load_templates subtemplates/icon.tpl}
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
                        <small class="text-muted">{icon "flash"} {_ Buzz}</small>
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
            {if Laddr\ProjectBuzzRequestHandler::checkWriteAccess($Buzz)}
                <div class="btn-group-sm pull-right">
                    <a href="{$Buzz->getURL()}/edit" class="btn btn-secondary">{icon "pencil"} <span class="sr-only">{_ Edit}</span></a>
                    <a href="{$Buzz->getURL()}/delete" class="btn btn-danger">{icon "trash"} <span class="sr-only">{_ Delete}</span></a>
                </div>
            {/if}

            <small class="text-muted">
                {icon "user"}&nbsp;{personLink $Buzz->Creator}
                &emsp;
                {icon "clock-o"}&nbsp;<a href="{$Buzz->getURL()}">{timestamp $Buzz->Created}</a>
            </small>
        </footer>
    </article>
{/template}
