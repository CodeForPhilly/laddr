{load_templates subtemplates/timestamp.tpl}
{load_templates subtemplates/people.tpl}

{template projectBuzz Buzz headingLevel=h2 showHeading=true showProject=true articleClass=""}
    <article class="project-buzz {$articleClass}">
        {if $showHeading}
            <{$headingLevel}>
                {if Laddr\ProjectBuzzRequestHandler::checkWriteAccess($Buzz)}
                    <div class="btn-group pull-right">
                        <a href="{$Buzz->getURL()}/edit" class="btn btn-mini">Edit</a>
                        <a href="{$Buzz->getURL()}/delete" class="btn btn-mini btn-warning">Delete</a>
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
                <a class="btn btn-info" href="{$Buzz->URL|escape}">Read the full article on {$Buzz->URL|parse_url:$.const.PHP_URL_HOST} &raquo;</a>
            </div>
            <p class="muted"><small>Published on {timestamp $Buzz->Published}, shared by {personLink $Buzz->Creator avatar=off} on {timestamp $Buzz->Created}</small></p>
        </div>
    </article>
{/template}