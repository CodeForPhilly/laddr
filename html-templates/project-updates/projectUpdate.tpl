{extends designs/site.tpl}

{block title}Update #{$data->Number|escape} &mdash; {$data->Project->Title|escape} &mdash; {$dwoo.parent}{/block}

{block content}
    {$Update = $data}
    {projectUpdate $Update}
{/block}