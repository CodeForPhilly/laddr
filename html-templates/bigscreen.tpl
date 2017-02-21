{extends designs/site.tpl}

{block css}
    {$dwoo.parent}

    <style type="text/css">
        .bigscreen-content, .bigscreen-content code {
            font-size: 140%;
        }

        .checkins ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .checkins li {
            margin-bottom: 0.5em;
            border-bottom: 1px dashed #AAA;
            padding-bottom: 0.5em;
        }

        .checkins li time {
            display: block;
            text-align: right;
            color: #666;
            font-size: 90%;
        }

        .screenshot {
            box-shadow: rgba(0, 0, 0, 0.8) 0px 0px 15px;
            max-width: 90%;
        }
    </style>
{/block}

{block js-bottom}
    {$dwoo.parent}

    {if !$.User->hasAccountLevel('Staff')}
        <script>
            setTimeout(function() {
                location.reload();
            }, 30000);
        </script>
    {/if}
{/block}

{block "js-analytics"}{*Ignore this page for analytics*}{/block}

{block content-wrapper}
    <div class="container-fluid bigscreen-content">
    {block content}

        <div class="row">
            <section class="col-md-4 announcements">
                {contentBlock "bigscreen-announcement"}
            </section>

            <section class="col-md-4">
                <h2>{_("Check in at %s")|sprintf:$.server.HTTP_HOST}</strong></h2>
                <img src="{versioned_url 'img/screenshot-checkin.png'}" class="screenshot">
            </section>

            <section class="col-md-4 checkins">
                <h2>{_ "Latest Checkins"}</h2>
                {if count($checkins)}
                    <p class="lead">{$checkins|count} checkin{tif count($checkins) > 1 ? 's'} so far for this event:</p>
                    <ul>
                        {foreach item=Checkin from=$checkins}
                            <li>
                                {personLink $Checkin->Member photo=yes photoSize=32} checked in{if $Checkin->Project} to {projectLink $Checkin->Project}{else}.{/if}
                                {timestamp $Checkin->Created}
                            </li>
                        {/foreach}
                    </ul>
                {/if}
            </section>
        </div>

    {/block}
    </div>
{/block}