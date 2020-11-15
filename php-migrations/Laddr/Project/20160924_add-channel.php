<?php

use Laddr\Project;

// skip conditions
if (!static::tableExists(Project::$tableName)) {
    printf("Skipping migration because table `%s` does not exist yet\n", Project::$tableName);

    return static::STATUS_SKIPPED;
}

if (static::columnExists(Project::$tableName, 'ChatChannel')) {
    printf("Skipping migration because column `ChatChannel` in table `%s` already exists\n", Project::$tableName);

    return static::STATUS_SKIPPED;
}

// migration
printf("Adding `ChatChannel` column to `%s` table\n", Project::$tableName);
DB::nonQuery('ALTER TABLE `%s` ADD `ChatChannel` varchar(255) NULL default NULL', Project::$tableName);

printf("Adding `ChatChannel` column to `%s` table\n", Project::$historyTable);
DB::nonQuery('ALTER TABLE `%s` ADD `ChatChannel` varchar(255) NULL default NULL', Project::$historyTable);

// done
return static::STATUS_EXECUTED;
