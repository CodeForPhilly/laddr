{template pagingLinks total pageSize=12 showAll=false}
    <nav aria-label="Page navigation">
        <ul class="pagination">
            {if $total > $pageSize}
                {$previousOffset = tif($.get.offset && $.get.offset > $pageSize ? $.get.offset - $pageSize : 0)}
                {$nextOffset = tif($.get.offset ? $.get.offset + $pageSize : $pageSize)}
                <li class="{if $.get.offset == 0}disabled{/if}">
                    <a href="?{refill_query limit=$pageSize offset=$previousOffset}" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>

                {foreach item=page from=range(1,ceil($total/$pageSize))}
                    {math "($page-1)*$pageSize" assign=offset}
                    <li class="{if $.get.offset == $offset}active{/if}"><a href="?{refill_query limit=$pageSize offset=$offset}">{$page}</a></li>
                {/foreach}

                {if $.get.offset < $total - $pageSize}
                    <li>
                        <a href="?{refill_query limit=$pageSize offset=$nextOffset}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                {/if}
            {/if}
        </ul>
    </nav>
{/template}