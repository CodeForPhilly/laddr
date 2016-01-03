{extends designs/site.tpl}

{block title}Person &mdash; {$dwoo.parent}{/block}

{block content}
    <header class="page-header">
        <h2>{_ "Deleted&hellip;"}</h2>
    </header>

    <p class="lead reading-width">{_("Person has been removed from %s")|sprintf:Laddr::$siteName|escape}!</p>

    <a href="/people">{_ "Retun to member list"}</a>
{/block}
