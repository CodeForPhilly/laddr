{extends "designs/site.tpl"}

{block content}
    <h2>Registered Members</h2>
    <ul class="thumbnails members-list">
        {foreach item=Person from=$data}
            <li class="span2">
                <div class="thumbnail">
                    {personLink $Person photo=yes photoSize=200}
                </div>
             </li>
        {/foreach}
    </ul>
{/block}