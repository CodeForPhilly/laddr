{load_templates subtemplates/timestamp.tpl}
{load_templates subtemplates/people.tpl}

{template projectBuzz Buzz headingLevel=h2 showHeading=true showProject=true articleClass=""}
    <article class="project-buzz {$articleClass}">
        {if $showHeading}
            <{$headingLevel}>
                {if Laddr\ProjectBuzzRequestHandler::checkWriteAccess($Buzz)}
                    <div class="btn-group pull-right">
                        <a href="{$Buzz->getURL()}/edit" class="btn btn-xs">{_ Edit}</a>
                        <a href="{$Buzz->getURL()}/delete" class="btn btn-xs btn-warning">{_ Delete}</a>
                    </div>
                {/if}
                {if $showProject}
                    <a href="{$Buzz->Project->getURL()}">{$Buzz->Project->Title|escape}</a>
                    <small><a href="{$Buzz->getURL()}">{$Buzz->Headline|escape}</a></small>
                {else}
                    <a href="{$Buzz->getURL()}">{$Buzz->Headline|escape}</a>
                {/if}
            </{$headingLevel}>
        {/if}
        <div class="buzz-body well">
            <div class="buzz-summary clearfix">
                {if $Buzz->Image}
                    <img class="pull-right" src="{$Buzz->Image->getThumbnailRequest(300, 300)}">
                {/if}
                {$Buzz->Summary|markdown}
                <a class="btn btn-info" href="{$Buzz->URL|escape}">{sprintf(_("Read the full article on %s"), parse_url($Buzz->URL, $.const.PHP_URL_HOST))} &raquo;</a>
            </div>
            {capture assign=timestampPublished}{timestamp $Buzz->Published}{/capture}
            {capture assign=sharedByLink}{personLink $Buzz->Creator avatar=off}{/capture}
            {capture assign=timestampCreated}{timestamp $Buzz->Created}{/capture}
            <p class="muted"><small>{sprintf(_("Published on %s, shared by %s on %s"), $timestampPublished, $sharedByLink, $timestampCreated)}</small></p>
        </div>
    </article>
{/template}