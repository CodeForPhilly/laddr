{extends designs/site.tpl}

{block title}{_ "Redirects"} &mdash; {$dwoo.parent}{/block}

{block css}
    {$dwoo.parent}
    <style>
        .redirects-cell-from input, .redirects-cell-to input {
            width: 100%;
        }
    </style>
{/block}

{block content}
    {$Redirect = $data}

    {if $Redirect->isPhantom}
        <h2>{_ "Create Redirect"}</h2>
    {else}
        <h2>{"Edit Redirect %u"|_|sprintf:$Redirect->ID}</h2>
    {/if}

    {validationErrors $Redirect->validationErrors}

    <table class="redirects-table">
        <thead>
            <tr>
                <th>From</th>
                <th>To</th>
            </tr>
        </thead>
        <tbody>
            <form method="POST">
                <tr class="redirects-row">
                    <td class="redirects-cell-from"><input name="From" value="{refill default=$Redirect->From}"></td>
                    <td class="redirects-cell-to"><input name="To" value="{refill default=$Redirect->To}"></td>
                    <td class="redirects-cell-action"><input type="submit" value="{tif $Redirect->isPhantom ? Create : Update} Redirect"></td>
                </tr>
            </form>
        </tbody>
    </table>
{/block}