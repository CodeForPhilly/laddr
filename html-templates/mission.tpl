{extends designs/site.tpl}

{block title}{_ "Our Mission"} &mdash; {$dwoo.parent}{/block}

{block content}
    <header class="page-header">
        <h2>{_ "Our Mission"}</h2>
    </header>

    {capture assign=aboutMarkdown}
[Code for America](http://www.codeforamerica.org/) is a 501(c)3
non-profit that envisions a government by the people, for the people,
that works in the 21st century.

Our programs change how we participate in government by:

- Connecting citizens and governments to design better services,
- Encouraging low-risk settings for innovation; and,
- Supporting a competitive civic tech marketplace.
    {/capture}

    {_($aboutMarkdown)|markdown}

    <iframe width="560" height="315" src="//www.youtube.com/embed/kDFhzNfd-bg?rel=0" frameborder="0" allowfullscreen></iframe>
{/block}