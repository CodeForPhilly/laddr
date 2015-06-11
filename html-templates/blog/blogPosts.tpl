{extends designs/site.tpl}

{block "css"}
    {$dwoo.parent}
    {cssmin "blog.css"}
{/block}

{block "content"}
    {load_templates "subtemplates/blog.tpl"}
    {load_templates "subtemplates/paging.tpl"}
    
    <header class="page-header">
        <div class="pull-right">
            <a href="/blog/create" class="btn btn-success btn-lg">New Post</a>
        </div>            
        <h1 class="header-title title-1">Blog Feed</h1>
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