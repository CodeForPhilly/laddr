{extends designs/site.tpl}

{block title}Project Deleted &mdash; {$dwoo.parent}{/block}
     	 
{block content}
    <p>Project  {$data->Title|escape} deleted.</p>       
{/block}