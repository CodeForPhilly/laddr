<?php

use Laddr\MemberCheckin;

$columnName = 'MeetupID';
$newType = 'varchar(255)';

// skip conditions
if (!static::tableExists(MemberCheckin::$tableName)) {
    printf("Skipping migration because table `%s` does not exist yet\n", MemberCheckin::$tableName);
    return static::STATUS_SKIPPED;
}

if (static::getColumnType(MemberCheckin::$tableName, $columnName) == $newType) {
    printf("Column `%s`.`%s` is already type %s\n", MemberCheckin::$tableName, $columnName, $newType);
    return static::STATUS_SKIPPED;
}


// migration
printf("Changing column `%s`.`%s` to type %s\n", MemberCheckin::$tableName, $columnName, $newType);
DB::nonQuery(
    'ALTER TABLE `%1$s` CHANGE `%2$s` `%2$s` %3$s NULL default NULL',
    [
        MemberCheckin::$tableName,
        $columnName,
        $newType
    ]
);


// done
return static::STATUS_EXECUTED;