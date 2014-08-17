<?php

Git::$repositories['laddr'] = array(
    'remote' => 'git@github.com:CfABrigadePhiladelphia/laddr.git'
    ,'originBranch' => 'master'
	,'workingBranch' => 'laddr.poplar.phl.io'
	,'localOnly' => true
	,'trees' => array(
		'html-templates'
		,'php-classes'
    	,'php-config'
    	,'php-migrations'
		,'site-root'
        ,'locales'
	)
);