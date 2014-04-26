{extends designs/site.tpl}

{block title}Project Buzz &mdash; {$dwoo.parent}{/block}

{block content}
    <h2>
        <div class="btn-group pull-right">
            <a href="{Laddr\ProjectBuzz::$collectionRoute}/create" class="btn btn-mini btn-primary">Add Buzz</a>
        </div>

        Latest Buzz
        {if $Project}
            in <a href="{$Project->getURL()}">{$Project->Title|escape}</a>
        {/if}
    </h2>

    {foreach item=Buzz from=$data}
        {projectBuzz $Buzz headingLevel=h3}
    {/foreach}

{/block}