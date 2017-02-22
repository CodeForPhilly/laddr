{load_templates subtemplates/meetups.tpl}
{load_templates subtemplates/projects.tpl}
{load_templates subtemplates/people.tpl}

{if $nextMeetup}
    <h2>{_ "Next Meetup"} <i style="color:#dd3333" class="fa fa-meetup" aria-hidden="true"></i></h2>
    {meetup $nextMeetup}
{/if}

{if count($futureMeetups)}
    <h2>{_ "Future Meetups"} <i style="color:#dd3333" class="fa fa-meetup" aria-hidden="true"></i></h2>
    {foreach item=futureMeetup from=$futureMeetups}
        {meetup $futureMeetup}
    {/foreach}
{/if}
