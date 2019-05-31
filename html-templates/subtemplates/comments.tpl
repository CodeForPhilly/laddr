{load_templates "subtemplates/personName.tpl"}
{load_templates "subtemplates/contextLinks.tpl"}
{load_templates "subtemplates/people.tpl"}
{load_templates "subtemplates/forms.tpl"}
{load_templates "subtemplates/timestamp.tpl"}

{template commentForm Context url=no Comment=no}
    {if $.Session->Person}
        {if $Comment}
            {$url = cat($Comment->getURL() '/edit')}
        {elseif !$url}
            {$url = cat($Context->getURL() '/comment')}
        {/if}

        <form class="comment-form" action="{$url|escape}" method="POST">
            <fieldset class="comment">
                <div class="author">{avatar $.User size=64}</div>

                <div class="message form-group">
                    <label for="Message">{personName $.User}</label>
                    <textarea rows="7" class="form-control" name="Message" id="Message" required aria-required="true">{refill field=$inputName default=$default}</textarea>
                    <p class="help-block">
                        You can use <a href="http://daringfireball.net/projects/markdown/basics" target="_blank">Markdown</a> for formatting.
                    </p>

                    <button type="submit" class="btn btn-primary">{tif $Comment ? Edit : Post} Comment</button>
                </div>
            </fieldset>
        </form>
    {else}
        <p class="login-hint well"><a class="button primary" href="/login?return={$Context->getURL()|escape:url}">Log in</a> to post a comment.</p>
    {/if}
{/template}

{template commentsList comments contextLinks=off}
    <section class="comments-list">
    {foreach item=Comment from=$comments}
        <article class="comment" id="comment-{$Comment->ID}">
            <div class="author">
                <a href="{$Comment->Creator->getURL()}">{avatar $Comment->Creator size=64}</a>
            </div>
            <div class="message">
                <header class="message-header">
                    <strong>{personLink $Comment->Creator}</strong>
                    &middot; <time><a href="#comment-{$Comment->ID}">{timestamp $Comment->Created}</a></time>
                    {if Emergence\Comments\CommentsRequestHandler::checkWriteAccess($Comment)}
                        &middot;
                        <div class="btn-group">
                            {if $.User->hasAccountLevel(Staff)}
                                <a href="{$Comment->getURL()}/edit" class="btn btn-sm btn-secondary">{*glyph "pencil"*} {_ Edit}</a>
                            {/if}
                            <a href="{$Comment->getURL()}/delete"
                               class="btn btn-sm btn-danger confirm"
                               data-confirm-yes="Delete Comment"
                               data-confirm-no="Don&rsquo;t Delete"
                               data-confirm-title="Deleting Comment"
                               data-confirm-body="Are you sure you want to delete this comment from {personName $Comment->Creator}?"
                               data-confirm-destructive="true"
                               data-confirm-success-target=".comment"
                               data-confirm-success-message="Comment deleted">Delete</a>
                        </div>
                    {/if}

                </header>
                <div class="message-body content-markdown">{$Comment->Message|escape|markdown}</div>
            </div>
        </article>
    {foreachelse}
        <p class="empty-text section-info">No comments have been posted yet.</p>
    {/foreach}
    </section>
{/template}

{template commentSection Item}
    <section class="comments reading-width" id="comments">
        <header class="section-header">
            <h2 class="header-title">{_ Comments}</h2>
        </header>
        {commentsList $Item->Comments}
        {commentForm $Item}
    </section>
{/template}
