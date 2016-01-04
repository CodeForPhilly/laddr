{extends designs/site.tpl}

{block title}{_ "Person deleted"} &mdash; {$dwoo.parent}{/block}

{block content}
    <header class="page-header">
        <h2>{_ "Person deleted"}</h2>
    </header>

    {capture assign=personName}{personName $data}{/capture}
    <p class="lead reading-width">{sprintf("%s has been removed from %s"|_, $personName, Laddr::$siteName)}!</p>

    <a href="/people">{_ "Retun to member list"}</a>
{/block}