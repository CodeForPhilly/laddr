{template meetup event headingLevel=h3 showRsvp=true}
    <article class="event card">
      <div class="card-body">
        <{$headingLevel} class="event-title">{$event.title|escape}</{$headingLevel}>

        <p class="event-meta">
          {strip}
            <time datetime="{$event.time_start->getTimestamp()|date_format:'%Y-%m-%dT%G:%M'}">
              {$event.time_start->getTimestamp()|date_format:"%A, %b %e <br> %l:%M%P"}
            </time>
            –
            <time datetime="{$event.time_end->getTimestamp()|date_format:'%Y-%m-%dT%G:%M'}">
              {$event.time_end->getTimestamp()|date_format:"%l:%M%P"}
            </time>
            &#32;@&nbsp;
            <a target="_blank" href="http://maps.google.com/?q={$event.location.name|escape:url},{$event.location.address|escape:url}">
              {$event.location.name|default:$event.location.address|escape}
            </a>
          {/strip}
        </p>

        {if $showRsvp}
            <p>
              <a href="{$event.url|escape}">
                {sprintf(_("RSVP @ %s"), parse_url($event.url, $.const.PHP_URL_HOST))}
              </a>
              {if $event.yes_rsvp_count}
                {* not currently available in the data :'( *}
                ({_("%s so far")|sprintf:$event.yes_rsvp_count})
              {/if}
            </p>
        {/if}
      </div>
    </article>
{/template}
