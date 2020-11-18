{extends designs/site.tpl}

{block "meta-info"}

    {$Post = $data}
    <meta name="description" content="{$Post->Summary|default:$Post->Title|escape}" />

    <meta property="og:site_name" content="{Laddr::$siteName|escape}" />
    <meta property="og:url" content="http://{Site::getConfig(primary_hostname)}{$Post->getURL()}" />
    <meta property="og:type" content="article">
    <meta property="og:title" content="{$Post->Title|escape}" />

    {if $Post->Summary}
        <meta property="og:description" content="{$Post->Summary|escape}" />
        <meta property="twitter:description" content="{$Post->Summary|escape}" />
    {/if}

    <meta property="article:published_time" content="{date($.const.DATE_W3C, $Post->Published)}" />
    <meta property="article:author" content="http://{Site::getConfig(primary_hostname)}{$Post->Author->getURL()}" />

    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="{$Post->Title|escape}" />

    {if $Post->Summary}
    {/if}

    {if \RemoteSystems\Twitter::$siteHandle}
        <meta name="twitter:site" content="@{\RemoteSystems\Twitter::$siteHandle}" />
        <meta name="twitter:creator" content="@{\RemoteSystems\Twitter::$siteHandle}" />
    {/if}

    <?php
    
    // find best media in post
    $imageUrl = null;

    foreach ($this->scope['Post']->Items AS $Item) {
        if ($Item->isA(\Emergence\CMS\Item\Media::class) && $Item->Media) {
            $imageUrl = $Item->Media->getThumbnailRequest(\Emergence\CMS\Item\Media::$fullWidth, \Emergence\CMS\Item\Media::$fullHeight);
        }
    }

    // default to site logo
    if (!$imageUrl && Site::resolvePath('site-root/img/cover.jpg')) {
        $imageUrl = Site::getVersionedRootUrl('img/cover.jpg');
    }

    $this->scope['imageUrl'] = $imageUrl;
    ?>

    {if $imageUrl}
        <link rel="image_src" href="{$imageUrl|escape}" />
        <meta property="og:image" content="{$imageUrl|escape}" />
        <meta name="twitter:image" content="{$imageUrl|escape}" />
    {/if}
{/block}

{block "css"}
    {$dwoo.parent}
    {cssmin "pages/article.css"}
{/block}

{block "title"}{$data->Title} &mdash; {$dwoo.parent}{/block}

{block "content-wrapper"}
    <div class="container-fluid">
    {block "content"}

        {$Post = $data}

        <article class="article">
            <header class="article-header">
                {if Emergence\CMS\BlogRequestHandler::checkWriteAccess($Post)}
                    <div class="btn-toolbar pull-right">
                        <div class="btn-group">
                            <a href="{$Post->getURL()}/edit" class="btn btn-secondary">{*glyph "pencil"*} {_ Edit}</a>
                            <a href="{$Post->getURL()}/delete"
                               class="btn btn-danger confirm"
                               data-confirm-yes="{_ 'Delete Post'}"
                               data-confirm-no="{_ 'Don&rsquo;t Delete'}"
                               data-confirm-title="{_ 'Deleting Post'}"
                               data-confirm-body="{_ 'Are you sure you want to delete the post'} &ldquo;{$Post->Title|escape}?&rdquo;"
                               data-confirm-destructive="true"
                               data-confirm-success-target=".blog-post"
                               data-confirm-success-message="{_ 'Blog post deleted'}">{*glyph "trash"*} {_ Delete}</a>
                        </div>
                    </div>
                {/if}

                <h1 class="header-title"><a href="{$Post->getURL()}">{$Post->Title|escape}</a></h1>

               {capture assign=authorData}{personLink $Post->Author photo=yes photoSize=36 pixelRatio=2 summary=no}{/capture}
               {capture assign=authoredDate}<a href="{$Post->getURL()}">{timestamp $Post->Published}</a>{/capture}

                <div class="article-meta">
                    {sprintf(_("on %s by %s"), $authorData, $authoredDate)}
                </div>

                {if $Post->Summary}
                <div class="article-summary">
                    {$Post->Summary|escape}
                </div>
                {/if}
            </header>

            <div class="article-body">
                {$Post->RenderBody()}
            </div>

            <section class="article-comments">
                {commentSection $Post}
            </section>
        </article>

    {/block}
    </div>
{/block}
