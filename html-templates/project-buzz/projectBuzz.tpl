{extends designs/site.tpl}

{block title}Buzz: {$data->Headline|escape} &mdash; {$data->Project->Title|escape} &mdash; {$dwoo.parent}{/block}

{block content}
    {$Buzz = $data}
    {projectBuzz $Buzz}
{/block}