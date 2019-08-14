<?php

$newType = 'enum(\'Emergence\\\\People\\\\Person\',\'Emergence\\\\People\\\\User\')';


// skip conditions
if (!static::tableExists('people')) {
    printf("Skipping migration because table `people` does not exist yet\n");
    return static::STATUS_SKIPPED;
}

if (static::getColumnType('people', 'Class') == $newType) {
    printf("Skipping migration because `Class` column already has correct type\n");
    return static::STATUS_SKIPPED;
}


// migration
print("Upgrading people table\n");
DB::nonQuery('ALTER TABLE `people` CHANGE `Class` `Class` ENUM("Person","User","Emergence\\\\People\\\\Person","Emergence\\\\People\\\\User") NOT NULL');
DB::nonQuery('UPDATE `people` SET `Class` = "Emergence\\\\People\\\\Person" WHERE `Class` = "Person"');
DB::nonQuery('UPDATE `people` SET `Class` = "Emergence\\\\People\\\\User" WHERE `Class` = "User"');
DB::nonQuery('ALTER TABLE `people` CHANGE `Class` `Class` '.$newType.' NOT NULL');

print("Upgrading history_people table\n");
DB::nonQuery('ALTER TABLE `history_people` CHANGE `Class` `Class` ENUM("Person","User","Emergence\\\\People\\\\Person","Emergence\\\\People\\\\User") NOT NULL');
DB::nonQuery('UPDATE `history_people` SET `Class` = "Emergence\\\\People\\\\Person" WHERE `Class` = "Person"');
DB::nonQuery('UPDATE `history_people` SET `Class` = "Emergence\\\\People\\\\User" WHERE `Class` = "User"');
DB::nonQuery('ALTER TABLE `history_people` CHANGE `Class` `Class` '.$newType.' NOT NULL');


return static::STATUS_EXECUTED;