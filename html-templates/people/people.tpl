{extends "designs/site.tpl"}

{block content}
    <h2>Registered Members</h2>
    {foreach item=Person from=$data}
        {if $.foreach.default.index % 6 == 0}<div class="row members-list">{/if}
            <div class="col-sm-2">
                {personLink $Person photo=yes photoSize=150 linkCls="thumbnail"}
            </div>
        {if $.foreach.default.index % 6 == 5 || $.foreach.default.last}</div>{/if}
    {/foreach}
{/block}