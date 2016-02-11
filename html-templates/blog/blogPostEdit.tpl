{extends content/contentEdit.tpl}

{block "css"}
    {$dwoo.parent}
    {cssmin "pages/blog.css"}
{/block}

{block title}{if $data->isPhantom}Create blog post{else}Edit &ldquo;{$data->Title|escape}&rdquo;{/if} &mdash; {$dwoo.parent}{/block}