{extends "designs/site.tpl"}

{block "content"}
<div class="row">
    <div class="col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">
        <div class="page-header">
            {if $data->getTitle()}
                <h1>Delete {$data->getTitle()}</h1>
            {else}
                <h1>Please confirm</h1>
            {/if}
        </div>
        <p class="confirm">{$question}</p>
        <form method="POST">
            <button type="button" class="btn btn-secondary margin-right" name="Sure" value="No" onclick="javascript:history.go(-1);">No</button>
            <button type="submit" class="btn btn-danger" name="Sure">Yes</button>
        </form>
    </div>
</div>
{/block}
