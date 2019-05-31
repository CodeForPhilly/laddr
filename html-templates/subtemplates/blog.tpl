{load_templates "subtemplates/personName.tpl"}
{load_templates "subtemplates/icon.tpl"}
{load_templates "subtemplates/people.tpl"}
{load_templates "subtemplates/comments.tpl"}
{load_templates "subtemplates/contextLinks.tpl"}
{load_templates "subtemplates/timestamp.tpl"}

{template blogPost Post headingLevel=h1 showHeader=true showBody=true showFooter=true showComments=false showCommentsSummary=true showContext=true useSummary=false}
    <article class="post card mb-4 {if $headingLevel=='h1'}reading-width{/if}">
        <div class="card-body">
            {if $showHeader}
                <header class="post-header">
                    <{$headingLevel} class="post-title">
                        <a class="pull-right" href="{$Post->Author->getURL()}" data-toggle="tooltip" title="{personName $Post->Author}">{avatar $Post->Author size=64}</a>
                        <a href="{$Post->getURL()}">{$Post->Title|escape}</a>
                    </{$headingLevel}>
                </header>
            {/if}
    
            {if $useSummary && $Post->Summary}
                <div class="post-summary">
                    <p>{$Post->Summary|escape}</p>
                    <div><a class="btn btn-info" href="{$Post->getURL()}">{_ "Read more&hellip;"}</a></div>
                </div>
            {elseif $showBody}
                <div class="post-body">
                    {$Post->renderBody()}
                </div>
            {/if}
        </div>

        {if $showFooter}
            <footer class="post-footer card-footer clearfix">
                {if Emergence\CMS\BlogRequestHandler::checkWriteAccess($Post)}
                <div class="btn-group pull-right">
                    <a href="{$Post->getURL()}/edit" class="btn btn-sm btn-secondary">{icon "pencil"} <span class="sr-only">{_ Edit}</span></span></a>
                    <a href="{$Post->getURL()}/delete"
                       class="btn btn-sm btn-danger confirm"
                       data-confirm-yes="Delete Post"
                       data-confirm-no="Don&rsquo;t Delete"
                       data-confirm-title="Deleting Post"
                       data-confirm-body="Are you sure you want to delete the post &ldquo;{$Post->Title|escape}?&rdquo;"
                       data-confirm-destructive="true"
                       data-confirm-success-target=".blog-post"
                       data-confirm-success-message="Blog post deleted">{icon "trash"} <span class="sr-only">{_ Delete}</span></a>
                </div>
                {/if}
    
                <small class="text-muted">
                    {icon "user"}&nbsp;{personLink $Post->Author}
                    &emsp;
                    {icon "clock-o"}&nbsp;<a href="{$Post->getURL()}">{timestamp $Post->Published}</a>
                </small>
                
                &emsp;
    
                {if $showCommentsSummary}
                    <small class="post-comments text-muted">
                        {icon "comment"}&nbsp;
                        <a href="{$Post->getUrl()}#comments">{strip}
                            {if $Post->Comments}
                                {count($Post->Comments)} Comment{tif count($Post->Comments) != 1 ? s}
                            {else}
                                Be the first to comment.
                            {/if}
                        {/strip}</a>
                    </small>
                {/if}
                {if $Post->Tags && $showCommentsSummary} &emsp; {/if}
                {if $Post->Tags}
                    <small class="post-tags text-muted">
                        {icon "tag"}&nbsp;<span class="sr-only">Tags: </span>{foreach item=Tag from=$Post->Tags implode=', '}<a href="{$Tag->getURL()}">{$Tag->Title|escape}</a>{/foreach}
                    </small>
                {/if}
            </footer>
        {/if}

        {if $showComments}
            {commentSection $Post}
        {/if}
    </article>
{/template}
