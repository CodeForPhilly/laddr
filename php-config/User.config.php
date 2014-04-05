<?php

User::$fields['Twitter'] = array(
    'notnull' => false
    ,'unique' => true
);

User::$relationships['OpenCheckin'] = array(
    'type' => 'one-one'
    ,'class' => 'Laddr\MemberCheckin'
    ,'local' => 'ID'
    ,'foreign' => 'MemberID'
    ,'conditions' => array(
        'OutTime IS NULL'
    )
);

User::$relationships['LastCheckin'] = array(
    'type' => 'one-one'
    ,'class' => 'Laddr\MemberCheckin'
    ,'local' => 'ID'
    ,'foreign' => 'MemberID'
    ,'order' => array(
        'ID' => 'DESC'
    )
);

User::$relationships['Checkins'] = array(
    'type' => 'one-many'
    ,'class' => 'Laddr\MemberCheckin'
    ,'foreign' => 'MemberID'
);

User::$relationships['Tags'] = array(
    'type' => 'many-many'
    ,'class' => 'Tag'
    ,'linkClass' => 'TagItem'
    ,'linkLocal' => 'ContextID'
    ,'conditions' => array('Link.ContextClass = "Person"')
);

User::$relationships['Comments'] = array(
    'type' => 'context-children'
    ,'class' => 'Comment'
    ,'contextClass' => __CLASS__
    ,'order' => array('ID' => 'DESC')
);

User::$relationships['Projects'] = array(
    'type' => 'many-many'
    ,'class' => 'Laddr\Project'
    ,'linkClass' => 'Laddr\ProjectMember'
    ,'linkForeign' => 'ProjectID'
    ,'linkLocal' => 'MemberID'
);

User::$relationships['ProjectMemberships'] = array(
    'type' => 'one-many'
    ,'class' => 'Laddr\ProjectMember'
    ,'foreign' => 'MemberID'
);