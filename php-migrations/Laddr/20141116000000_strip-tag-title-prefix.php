<?php

// skip conditions
if (!static::tableExists(Tag::$tableName)) {
    printf("Skipping migration because table `%s` does not exist yet\n", Tag::$tableName);
    return static::STATUS_SKIPPED;
}


// migration
printf("Removing prefixes from tag titles\n");
DB::nonQuery(
    'UPDATE `%s` SET Title = SUBSTRING(Title, LOCATE(".", Title) + 1) WHERE Handle LIKE "%%.%%" AND Title LIKE "%%.%%" AND SUBSTRING_INDEX(Handle, ".", 1) = SUBSTRING_INDEX(Title, ".", 1)',
    [
        Tag::$tableName
    ]
);


// done
return static::STATUS_EXECUTED;