{extends "designs/site.tpl"}

{block title}{_ 'Members'} &mdash; {$dwoo.parent}{/block}

{block "css"}
    {$dwoo.parent}
    {cssmin "pages/members.css"}
{/block}

{block js-bottom}
    {$dwoo.parent}
    {jsmin "features/sidebar-tags.js"}
{/block}

{block content}
    <div class="page-header">
        <h1>{_ "Registered Members"} <span class="badge">{$membersTotal|number_format}</span></h1>
    </div>

    <div class="row">
        <div class="col-sm-4 col-md-3">
            <div class="tagsSummary members">

                <header class="btn-group btn-group-justified btn-group-xs" role="group">
                    <a href="#members-by-tech" class="tagFilter active btn btn-default" role="button" data-group="byTech">{_ "skills"}</a>
                    <a href="#members-by-project" class="tagFilter btn btn-default" role="button" data-group="byTopic">{_ "projects"}</a>
                </header>

                {template tagLink tagData rootUrl linkCls=""}
                    <a class="{$linkCls}" href="{$rootUrl}?tag={$tagData.Handle}">{$tagData.Title}{if $tagData.itemsCount} <span class="badge pull-right">{$tagData.itemsCount|number_format}</span>{/if}</a>
                {/template}

                <div class="tags list-group byTech">
                    {foreach item=tag from=$membersTags.byTech}
                        {tagLink tagData=$tag rootUrl="/people" linkCls="list-group-item"}
                    {/foreach}
                </div>

                <div class="tags list-group byTopic" style="display: none">
                    {foreach item=tag from=$membersTags.byTopic}
                        {tagLink tagData=$tag rootUrl="/people" linkCls="list-group-item"}
                    {/foreach}
                </div>
            </div>
        </div>

        <div class="col-sm-8 col-md-9">
            {foreach item=Person from=$data}
                {if $.foreach.default.index % 6 == 0}<div class="row members-list">{/if}
                    <div class="col-sm-2">
                        {personLink $Person photo=yes photoSize=150 linkCls="thumbnail"}
                    </div>
                {if $.foreach.default.index % 6 == 5 || $.foreach.default.last}</div>{/if}
            {/foreach}
        </div>
    </div>
{/block}