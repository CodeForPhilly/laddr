<?php

use Laddr\Project;

// skip conditions
if (!static::tableExists(Project::$tableName)) {
    printf("Skipping migration because table `%s` does not exist yet\n", Project::$tableName);
    return static::STATUS_SKIPPED;
}

if (static::columnExists(Project::$tableName, 'Stage')) {
    printf("Skipping migration because column `Stage` in table `%s` already exists\n", Project::$tableName);
    return static::STATUS_SKIPPED;
}


// migration
printf("Adding `Stage` column to `%s` table\n", Project::$tableName);
DB::nonQuery('ALTER TABLE `%s` ADD `Stage` enum("Commenting","Bootstrapping","Prototyping","Testing","Maintaining","Drifting","Hibernating") NOT NULL default "Commenting"', Project::$tableName);

printf("Adding `Stage` column to `%s` table\n", Project::$historyTable);
DB::nonQuery('ALTER TABLE `%s` ADD `Stage` enum("Commenting","Bootstrapping","Prototyping","Testing","Maintaining","Drifting","Hibernating") NOT NULL default "Commenting"', Project::$historyTable);


// done
return static::STATUS_EXECUTED;