<?php

Git::$repositories['laddr'] = [
    'remote' => 'https://github.com/CfABrigadePhiladelphia/laddr.git',
    'originBranch' => 'develop',
    'workingBranch' => 'develop',
    'trees' => [
        'event-handlers',
        'html-templates' => [
            'exclude' => [
                // exclude files from emergence-redirects
                '#^/redirects/#',
                
                // exclude files from emergence-github
                '#^/connectors/github/#',
                
                // exclude files from emergence-slack
                '#^/connectors/slack/#'
            ]
        ],
        'locales',
        'php-classes/Drewm',
        'php-classes/Emergence/Events',
        'php-classes/Laddr',
        'php-classes/RemoteSystems',
        'php-classes/Laddr.php',
        'php-config' => [
            'exclude' => [
                // exclude files from emergence-redirects
                '#^/Site.config.d/redirects\.php$#',
                
                // exclude files from emergence-github
                '#^/Emergence/GitHub/#',
                '#^/Emergence/People/User\.config\.d/github-token\.php$#',
                
                // exclude files from emergence-slack
                '#^/Emergence/Slack/#',
                
                // exclude files from emergence-saml2
                '#^/Emergence/SAML2/#',
                '#^/SAML2/Compat/ContainerSingleton\.config\.php#',
                '#^/TableManagerRequestHandler\.config\.d/emergence-saml2\.php#',
                '#^/Git\.config\.d/simplesamlphp-saml2\.php#',
                '#^/Git\.config\.d/xmlseclibs\.php#'
                
            ]
        ],
        'php-migrations' => [
            'exclude' => [
                '#^/Emergence/GitHub/#'
            ]
        ],
        'site-root' => [
            'exclude' => [
                // exclude files from emergence-redirects
                '#^/redirects\.php$#',
                
                '#^/connectors/github\.php#',
                
                // exclude files from emergence-slack
                '#^/connectors/slack\.php#',
                
                // exclude files from emergence-saml2
                '#^/connectors/saml2\.php#',
            ]
        ]
    ]
];
