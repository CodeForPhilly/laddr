{extends designs/site.tpl}

{block title}Update #{$data->Number|escape} &mdash; {$data->Project->Title|escape} &mdash; {$dwoo.parent}{/block}

{block content}
    {$Update = $data}
    {$Project = $Update->Project}
    {$updateUrl = "http://$.server.HTTP_HOST/projects/$Project->Handle/updates/$Update->Number"}

    <div class="row-fluid">
        {projectUpdate $Update articleClass="span8"}

        <aside class="span4">
            <h3></h3>
            <a class="btn btn-mini" href="{RemoteSystems\Twitter::getTweetIntentURL('Check out $Project->TitlePossessive update #$Update->Number!', array(url = $updateUrl))}">Spread the word on Twitter!</a>
        </aside>
    </div>
{/block}