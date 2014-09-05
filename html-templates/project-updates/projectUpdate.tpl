{extends designs/site.tpl}

{block title}Update #{$data->Number|escape} &mdash; {$data->Project->Title|escape} &mdash; {$dwoo.parent}{/block}

{block content}
    {$Update = $data}
    {$Project = $Update->Project}
    {$updateUrl = "http://$.server.HTTP_HOST/projects/$Project->Handle/updates/$Update->Number"}

    <div class="row-fluid">
        {projectUpdate $Update articleClass="span8"}

        <aside class="twitterstream span4">
            <h3>
                Twitter mentions
                <a class="btn btn-mini" href="{RemoteSystems\Twitter::getTweetIntentURL('Check out $Project->TitlePossessive update #$Update->Number!', array(url = $updateUrl))}">Spread the word!</a>
            </h3>

            {twitter query=$updateUrl count=10}
            <dl class="tweetsCt">
                {foreach item=tweet from=$tweets}
                    <dt><img src="{$tweet.profile_image_url}"><a href="http://twitter.com/{$tweet.from_user}" target="_blank"><strong>{$tweet.from_user}:</strong></a></dt>
                    <dd>{$tweet.text|linkify:twitter}</dd>
                {foreachelse}
                    <dd><em>None yet.</em></dd>
                {/foreach}
            </dl>
        </aside>
    </div>
{/block}