{extends "designs/site.tpl"}

{block "css"}
    {$dwoo.parent}
    {cssmin "pages/members.css"}
{/block}

{block content}
    <header class="page-header">
        <h2>{_ "Registered Members"}</h2>
    </header>

    {foreach item=Person from=$data}
        {if $.foreach.default.index % 6 == 0}<div class="row members-list">{/if}
            <div class="col-sm-2">
                {personLink $Person photo=yes photoSize=150 linkCls="thumbnail"}
            </div>
        {if $.foreach.default.index % 6 == 5 || $.foreach.default.last}</div>{/if}
    {/foreach}
{/block}