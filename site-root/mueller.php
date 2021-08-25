<?php

$GLOBALS['Session']->requireAccountLevel('Administrator');
Site::$debug = true;
Site::$production = false;
error_reporting(E_ALL);
ini_set('display_errors', 1);

header('X-Accel-Buffering: no');
@ob_end_flush();

?>
<style>
    tr.bad {
        background-color: #FDD;
    }
    tr.good {
        background-color: #DFD;
    }
    tr.neutral {
        background-color: #DDD;
    }
    td.flags {
        white-space: nowrap;
    }
    td.purgings {
        max-width: 10em;
    }
    td.data {
        max-width: 10em;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    td.diagnostics {
        white-space: pre;
    }
</style>

<table width="100%">
<tr>
    <th>Score</th>
    <th>ID</th>
    <th>Username</th>
    <th>First Name</th>
    <th>Last Name</th>
    <th>Affiliation</th>
    <th>Email</th>
    <th>Twitter</th>
    <?php if (!empty($_REQUEST['show_diagnostics'])): ?><th>Diagnostics</th><?php endif ?>
    <th>Flags</th>
    <th>Purgings</th>
<tr>

<?php
$report = Emergence\Mueller\Investigator::scanUsers([
    'callback' => function ($User, $result) {
            echo '<tr class="'.($result['score'] == 0 ? 'neutral' : ($result['score'] < 0 ? 'bad' : 'good')).'">';
            echo '<td>'.$result['score'].'</td>';
            echo '<td class="data">'.$User->ID.'</td>';
            echo '<td class="data">'.$User->Username.'</td>';
            echo '<td class="data">'.$User->FirstName.'</td>';
            echo '<td class="data">'.$User->LastName.'</td>';
            echo '<td class="data">'.$User->Affiliation.'</td>';
            echo '<td class="data">'.$User->Email.'</td>';
            echo '<td class="data">'.$User->Twitter.'</td>';
            if (!empty($_REQUEST['show_diagnostics'])) echo '<td class="diagnostics">'.($result['diagnostics']?var_export(array_filter($result['diagnostics']), true):'').'</td>';
            echo '<td class="flags">'.implode(', ', $result['flags']).'</td>';
            echo '<td class="purgings">'.str_replace('&', '&thinsp;&amp;', http_build_query(array_filter($result['purgings']))).'</td>';
            echo '</tr>';

            // flush output after each row
            @ob_flush();
            flush();
    }
]);
?>

</table>

<pre>
<?php
var_export($report);
?>
</pre>