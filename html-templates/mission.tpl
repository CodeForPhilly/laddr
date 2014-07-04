{extends designs/site.tpl}

{block title}{_ "Our Mission"} &mdash; {$dwoo.parent}{/block}

{block content}
    <h2>{_ "Our Mission"}</h2>

    {_("Brigade_mission_body_markdown")|markdown}

    <iframe width="560" height="315" src="//www.youtube.com/embed/kDFhzNfd-bg?rel=0" frameborder="0" allowfullscreen></iframe>
{/block}