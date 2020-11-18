{extends "designs/site.tpl"}

{block title}Pages &mdash; {$dwoo.parent}{/block}

{block content}
    <div class="row">
        <div class="col-md-8 col-md-offset-2">
            {if Emergence\CMS\PagesRequestHandler::checkWriteAccess(\Emergence\CMS\Page::create())}
                <header class="page-header">
                    <form action="/pages/create" method="GET" class="pull-right">
                        {* field "Title" "Page Title" *}
                        <button type="submit" class="btn btn-success">{_ "Create New Page"}</button>
                    </form>
                    <h1>{_ "Pages Directory"}</h1>
                </header>
            {/if}

            <ul>
            {foreach item=Page from=$data}
                <li><a href="/pages/{$Page->Handle}">{$Page->Title|escape}</a></li>
            {/foreach}
            </ul>

        </div>
    </div>
{/block}
