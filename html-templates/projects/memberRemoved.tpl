{extends designs/site.tpl}

{block title}Members &mdash; {$dwoo.parent}{/block}

{block content}
    <p>{personLink $Member} {if $data && $data->Role}({$data->Role|escape}){/if} has been removed from {projectLink $Project}</p>
{/block}