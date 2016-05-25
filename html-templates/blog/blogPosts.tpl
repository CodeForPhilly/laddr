{extends designs/site.tpl}

{block "css"}
    {$dwoo.parent}
    {cssmin "pages/blog.css"}
{/block}

{block "content"}
    {load_templates "subtemplates/blog.tpl"}
    {load_templates "subtemplates/paging.tpl"}
    
    <header class="page-header">
        <div class="btn-toolbar pull-right">
            <a href="/blog/create" class="btn btn-success">New Post</a>
        </div>

        <h2>Blog Feed</h2>
    </header>
    
    <section class="page-section article-collection">
    {foreach item=BlogPost from=$data}
        {blogPost $BlogPost useSummary=true showBody=false}
    {foreachelse}
        <p class="empty-text">Stay tuned for the first post&hellip;</p>
    {/foreach}
    </section>

    {if $total > $limit}
    <footer class="page-footer">
        <strong>{$total|number_format} posts:</strong> {pagingLinks $total pageSize=$limit}
    </footer>
    {/if}
{/block}