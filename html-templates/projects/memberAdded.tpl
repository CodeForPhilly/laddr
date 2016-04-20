{extends designs/site.tpl}

{block title}{_ "Members"} &mdash; {$dwoo.parent}{/block}

{block content}
    {capture assign=person}{personLink $Member} {if $data->Role}({$data->Role|escape}){/if}{/capture}
    {capture assign=project}{projectLink $Project}{/capture}

    <p>{sprintf(_("%s has been added to %s"), $person, $project)}</p>
    <p>Giving us your feedback about this experience helps us make Code for Philly better. Please take <a href="https://codeforphilly.typeform.com/to/cYwSLW" target="_blank">this</a> short survey.</p>
    <p class="text-center"><a href="https://codeforphilly.typeform.com/to/cYwSLW" class="btn btn-lg btn-primary" target="_blank">Take Survey</a></p>

{/block}