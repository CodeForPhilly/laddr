{extends designs/site.tpl}

{block title}{_ "Redirects"} &mdash; {$dwoo.parent}{/block}

{block css}
    {$dwoo.parent}
    <style>
        .redirects-table {
            width: 100%;
        }

        .redirects-cell-from input, .redirects-cell-to input {
            width: 100%;
        }
    </style>
{/block}

{block content}
    <h2>{_ "Redirects"}</h2>

    <table class="redirects-table">
        <thead>
            <tr>
                <th>From</th>
                <th>To</th>
            </tr>

            <form action="/redirects/create" method="POST" id="create">
                <tr>
                    <td class="redirects-cell-from"><input name="From" value="{refill field=From}"></td>
                    <td class="redirects-cell-to"><input name="To" value="{refill field=To}"></td>
                    <td class="redirects-cell-action"><input type="submit" value="Add Redirect"></td>
                </tr>
            </form>
        </thead>

        <tbody>
            {foreach item=Redirect from=$data}
                <form action="{$Redirect->getUrl('/edit')}" method="POST" id="redirect-{$Redirect->ID}">
                    <tr class="redirects-row">
                        <td class="redirects-cell-from"><input name="From" value="{refill default=$Redirect->From}"></td>
                        <td class="redirects-cell-to"><input name="To" value="{refill default=$Redirect->To}"></td>
                        <td class="redirects-cell-action"><input type="submit" value="Update Redirect"> <a href="{$Redirect->getUrl('/delete')}">Delete Redirect</a></td>
                    </tr>
                </form>
            {/foreach}
        </tbody>
    </table>
{/block}