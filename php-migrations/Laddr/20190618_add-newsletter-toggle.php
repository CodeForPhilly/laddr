<?php

use Emergence\People\User;

// skip conditions
if (!static::tableExists(User::$tableName)) {
    printf("Skipping migration because table `%s` does not exist yet\n", User::$tableName);
    return static::STATUS_SKIPPED;
}

if (static::columnExists(User::$tableName, 'Newsletter')) {
    printf("Skipping migration because column `Newsletter` in table `%s` already exists\n", User::$tableName);
    return static::STATUS_SKIPPED;
}


// migration
printf("Adding `Newsletter` column to `%s` table\n", User::$tableName);
DB::nonQuery('ALTER TABLE `%s` ADD `Newsletter` boolean NULL default 1', User::$tableName);

printf("Adding `Newsletter` column to `%s` table\n", User::$historyTable);
DB::nonQuery('ALTER TABLE `%s` ADD `Newsletter` boolean NULL default 1', User::getHistoryTableName());


// done
return static::STATUS_EXECUTED;