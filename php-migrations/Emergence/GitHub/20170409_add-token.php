<?php

use Emergence\People\User;

// skip conditions
if (!static::tableExists(User::$tableName)) {
    printf("Skipping migration because table `%s` does not exist yet\n", User::$tableName);
    return static::STATUS_SKIPPED;
}

if (static::columnExists(User::$tableName, 'GitHubToken')) {
    printf("Skipping migration because column `GitHubToken` in table `%s` already exists\n", User::$tableName);
    return static::STATUS_SKIPPED;
}


// migration
printf("Adding `GitHubToken` column to `%s` table\n", User::$tableName);
DB::nonQuery('ALTER TABLE `%s` ADD `GitHubToken` varchar(255) NULL default NULL', User::$tableName);

printf("Adding `GitHubToken` column to `%s` table\n", User::$historyTable);
DB::nonQuery('ALTER TABLE `%s` ADD `GitHubToken` varchar(255) NULL default NULL', User::$historyTable);


// done
return static::STATUS_EXECUTED;