{template tagLink tagData rootUrl}
    <a href="{$rootUrl}?tag={$tagData.Handle}">{$tagData.Title|regex_replace:'/^[^\.]+\.\s*/':''}{if $tagData.itemsCount} <span class="badge pull-right">{$tagData.itemsCount|number_format}</span>{/if}</a>
{/template}