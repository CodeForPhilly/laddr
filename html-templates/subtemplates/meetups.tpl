{template meetup event headingLevel=h3 showRsvp=true}
    {$endTime = $event.time + $event.duration}
    <article class="event card">
      <div class="card-body">
        <{$headingLevel} class="event-title">{$event.name}</{$headingLevel}>

        <p class="event-meta">
            <time datetime="{$event.time/1000|date_format:'%Y-%m-%dT%G:%M'}">{$event.time/1000|date_format:"%A, %b %e <br> %l:%M%P"}</time>–<time datetime="{$endTime.time/1000|date_format:'%Y-%m-%dT%G:%M'}">{$endTime/1000|date_format:"%l:%M%P"}</time>
            &#32;@&nbsp;<a href="http://maps.google.com/?q={$event.venue.address_1},%20{$event.venue.zip}">{$event.venue.name}</a>
        </p>

        {if $showRsvp}
            <p><a href="{$event.event_url}">{sprintf(_("RSVP @ %s"), parse_url($event.event_url, $.const.PHP_URL_HOST))}</a> {if $event.yes_rsvp_count}({_("%s so far")|sprintf:$event.yes_rsvp_count}){/if}</p>
        {/if}
      </div>
    </article>
{/template}
