<?php

function Dwoo_Plugin_time_range(Dwoo_Core $dwoo, $start, $end, $showDate = false)
{
    $string = '';

    $startDate = strftime('%b %e', $start);
    $startHour = (int)strftime('%l', $start);
    $startMinute = (int)strftime('%M', $start);
    $startAmPm = strftime('%P', $start);

    $endDate = strftime('%b %e', $end);
    $endHour = (int)strftime('%l', $end);
    $endMinute = (int)strftime('%M', $end);
    $endAmPm = strftime('%P', $end);

    // start time
    if ($showDate) {
        $string .= $startDate.' ';
    }

    $string .= $startHour;

    if ($startMinute) {
        $string .= ':'.$startMinute;
    }

    if ($end && $start != $end) { // check that there is actually a range
        if ($startAmPm != $endAmPm) {
            $string .= $startAmPm;
        }

        // glue
        $string .= '&ndash;';

        // end time
        if ($showDate && ($endDate != $startDate)) {
            $string .= $endDate.' ';
        }

        $string .= $endHour;

        if ($endMinute) {
            $string .= ':'.$endMinute;
        }

        $string .= $endAmPm;
    } else { // otherwise append am/pm and be done
        $string .= $startAmPm;
    }

    return $string;
}