{extends designs/site.tpl}

{block title}{_ "Top Members"} &mdash; {$dwoo.parent}{/block}

{block content}
    <header class="page-header">
        <h2>{_ "Top Members"}</h2>
    </header>

    <table width="350">
        <tr>
            <th align="left">{_ Member}</th>
            <th align="right">{_ "Event checkins"}</th>
        </tr>
        {foreach item=row from=$data}
            <tr>
                <td align="left">{personLink $row.Member photo=yes}</td>
                <td align="right" width="50">{$row.Checkins|number_format}</td>
            </tr>
        {/foreach}
    </table>
{/block}
