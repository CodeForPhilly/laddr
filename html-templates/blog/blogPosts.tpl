{extends designs/site.tpl}

{block "css"}
    {$dwoo.parent}
    {cssmin "pages/article.css"}
{/block}

{block title}Blog &mdash; {$dwoo.parent}{/block}

{block "content"}
    {load_templates "subtemplates/blog.tpl"}
    {load_templates "subtemplates/paging.tpl"}

    <div class="row">
        <div class="col-md-8 col-md-offset-2">
    
            <header class="page-header">
                <a href="/blog/create" class="btn btn-success pull-right">New Post</a>

                <h1>Blog Feed</h1>
            </header>
            
            <section class="page-section article-collection">
            {foreach item=BlogPost from=$data}
                {blogPost $BlogPost useSummary=true showBody=false headingLevel="h2"}
            {foreachelse}
                <p class="empty-text">Stay tuned for the first post&hellip;</p>
            {/foreach}
            </section>

            {if $total > $limit}
            <footer class="page-footer">
                <strong>{$total|number_format} posts:</strong> {pagingLinks $total pageSize=$limit}
            </footer>
            {/if}

        </div>
    </div>
{/block}