{extends designs/site.tpl}

{block title}{_ "Person deleted"} &mdash; {$dwoo.parent}{/block}

{block content}
    <header class="page-header">
        <h2>{_ "Person deleted"}</h2>
    </header>

    <p class="lead reading-width">{_("Person has been removed from %s")|sprintf:Laddr::$siteName|escape}!</p>

    <a href="/people">{_ "Retun to member list"}</a>
{/block}