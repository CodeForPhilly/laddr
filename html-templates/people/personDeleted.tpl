{extends designs/site.tpl}

{block title}{_ "Person deleted"} &mdash; {$dwoo.parent}{/block}

{block content}
    <div class="page-header">
        <h1>{_ "Person deleted"}</h1>
    </div>

    {capture assign=personName}{personName $data}{/capture}
    <p class="lead">{sprintf("%s has been removed from %s"|_, $personName, Laddr::$siteName)}!</p>

    <p><a href="/people">{_ "Retun to member list"}</a></p>
{/block}