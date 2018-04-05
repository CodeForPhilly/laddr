{load_templates subtemplates/meetups.tpl}
{load_templates subtemplates/projects.tpl}
{load_templates subtemplates/people.tpl}

{if $nextMeetup}
    <h2>{_ "Next Meetup"} {icon "meetup"}</h2>
    {meetup $nextMeetup}
{/if}

{if count($futureMeetups)}
    <h2>{_ "Future Meetups"} {icon "meetup"}</h2>
    {foreach item=futureMeetup from=$futureMeetups}
        {meetup $futureMeetup}
    {/foreach}
{/if}
