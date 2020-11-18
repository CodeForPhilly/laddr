{extends "designs/site.tpl"}

{block "css"}
    {$dwoo.parent}
    {cssmin "pages/article.css"}
{/block}

{block title}{$data->Title|escape} &mdash; {$dwoo.parent}{/block}

{block "content-wrapper"}
    <div class="container-fluid">

        {block content}
            {$Page = $data}
            <article class="article cms-page reading-width">
                <header class="article-header">
                    {if Emergence\CMS\PagesRequestHandler::checkWriteAccess($Page, true)}
                        <div class="btn-toolbar pull-right">
                            <div class="btn-group">
                                <a href="{$Page->getURL()}/edit" class="btn btn-secondary">{_ Edit}</a>&nbsp;
                                <a href="{$Page->getURL()}/delete"
                                   class="btn btn-danger confirm"
                                   data-confirm-yes="{_ 'Delete Page'}"
                                   data-confirm-no="{_ 'Don&rsquo;t Delete'}"
                                   data-confirm-title="{_ 'Deleting Post'}"
                                   data-confirm-body="{_ 'Are you sure you want to delete the page'} &ldquo;{$Page->Title|escape}?&rdquo;"
                                   data-confirm-destructive="true"
                                   data-confirm-success-target=".cms-page"
                                   data-confirm-success-message="{_ 'Page deleted'}">{_ Delete}</a>
                            </div>
                        </div>
                    {/if}
                    <h1 class="header-title">
                        <a href="{$Page->getURL()}">{$Page->Title}</a>
                    </h1>
                </header>

                <section class="article-body">
                    {$Page->renderBody()}
                </section>
            </article>
        {/block}

    </div>
{/block}
