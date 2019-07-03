{extends "designs/site.tpl"}

{block title}{_ 'Members'} &mdash; {$dwoo.parent}{/block}

{block js-bottom}
    {$dwoo.parent}
    {jsmin "features/sidebar-tags.js"}
{/block}

{block content}
    {load_templates "subtemplates/paging.tpl"}

    <div class="page-header">
        <h1>{_ "Registered Members"} <span class="badge badge-secondary badge-pill">{$membersTotal|number_format}</span></h1>
    </div>

    {contentBlock "members-browse-introduction"}

    <div class="row">
        <div class="col-sm-4 col-md-3">
            <div class="tags-ct">
                <div class="btn-group btn-group-justified btn-group-sm margin-bottom" role="group">
                    <a href="#members-by-tech" class="tagFilter active btn btn-secondary" role="button" data-group="byTech">{_ "skills"}</a>
                    <a href="#members-by-project" class="tagFilter btn btn-secondary" role="button" data-group="byTopic">{_ "topics"}</a>
                </div>

                {template tagLink tagData rootUrl linkCls=""}
                    <a class="{$linkCls}" href="{$rootUrl}?tag={$tagData.Handle}">{$tagData.Title}{if $tagData.itemsCount} <span class="badge badge-pill badge-secondary pull-right">{$tagData.itemsCount|number_format}</span>{/if}</a>
                {/template}

                <div class="tags list-group byTech mb-4">
                    {foreach item=tag from=$membersTags.byTech}
                        {tagLink tagData=$tag rootUrl="/people" linkCls="list-group-item list-group-item-action"}
                    {/foreach}
                </div>

                <div class="tags list-group byTopic" style="display: none">
                    {foreach item=tag from=$membersTags.byTopic}
                        {tagLink tagData=$tag rootUrl="/people" linkCls="list-group-item list-group-item-action"}
                    {/foreach}
                </div>
            </div>
        </div>

        <div class="col-sm-8 col-md-9">
            <div class="row row-wrap">
            {foreach item=Person from=$data}
                <div class="col-sm-6 col-md-4">
                    {personLink $Person photo=yes photoSize=150 linkCls="thumbnail text-center"}
                </div>
            {/foreach}
            </div>

            <footer class="page-footer">
                {pagingLinks $total pageSize=$limit}
            </footer>
        </div>
    </div>
{/block}
