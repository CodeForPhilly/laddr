{extends designs/site.tpl}

{block title}{_ "Latest Events"} &mdash; {$dwoo.parent}{/block}

{block content}
    <header class="page-header">
        <h2>{_ "Latest Events"}</h2>
    </header>

    <table width="600">
        <tr>
            <th align="left">Meetup ID</th>
            <th align="left">First Checkin</th>
            <th align="left">Last Checkin</th>
            <th align="right">Checkins</th>
        </tr>
        {foreach item=row from=$data}
            <tr>
                <td align="left">{$row.MeetupID}</td>
                <td align="left">{$row.First|date_format:'%a %b %d, %Y &mdash; %l:%M%P'}</td>
                <td align="left">{$row.Last|date_format:'%a %b %d, %Y &mdash; %l:%M%P'}</td>
                <td align="right" width="50">{$row.Checkins|number_format}</td>
            </tr>
        {/foreach}
    </table>
{/block}