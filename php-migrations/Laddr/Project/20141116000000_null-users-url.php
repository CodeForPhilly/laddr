<?php

use Laddr\Project;

// skip conditions
if (!static::tableExists(Project::$tableName)) {
    printf("Skipping migration because table `%s` does not exist yet\n", Project::$tableName);
    return static::STATUS_SKIPPED;
}

if (static::getColumnIsNullable(Project::$tableName, 'UsersUrl')) {
    printf("Skipping migration because field `%s`.`UsersUrl` is already nullable\n", Project::$tableName);
    return static::STATUS_SKIPPED;
}


// migration
printf("Enabling NULL for `%s`.`UsersUrl`\n", Project::$tableName);
DB::nonQuery('ALTER TABLE `%s` CHANGE `UsersUrl` `UsersUrl` varchar(255) NULL default NULL', Project::$tableName);


printf("Enabling NULL for `%s`.`UsersUrl`\n", Project::$historyTable);
DB::nonQuery('ALTER TABLE `%s` CHANGE `UsersUrl` `UsersUrl` varchar(255) NULL default NULL', Project::$historyTable);


// done
return static::STATUS_EXECUTED;