<?php

function Dwoo_Plugin_extjs(Dwoo $dwoo, $include = array(), $plugins = array(), $debug = false, $version = '2', $jScout = false)
{
    /* Severely inefficient for convenience
     * TODO: something better, tied into an app with templates and dynamic loading?
     */
    $extRoot = dirname($_SERVER['DOCUMENT_ROOT']).'/static/ext';


    // parse include from string
    if (is_string($include)) {
        $include = preg_split('/[^a-zA-Z0-9_]+/', $include);
    }

    // set default include to current app name
    if (empty($include) || !is_array($include)) {
        $include = array(Site::$requestPath[0]);
    }

    // prepend common to beginning of array if it hasn't been explicitely placed
    if (!in_array('common', $include)) {
        array_unshift($include, 'common');
    }

    // init plugins array
    if (!is_array($plugins)) {
        if ($plugins) {
            $plugins = preg_split('/[^a-zA-Z0-9_.]+/', $plugins);
        } else {
            $plugins = array();
        }
    }

    // init include arrays
    $includeJS = array();
    $includeCSS = array();


    // jScout
    if ($jScout) {
        $includeJS[] = '/js/jScout.js';
    }


    // find plugins
    foreach ($plugins AS $plugin) {
        // js file
        if (file_exists("$extRoot/plugins/$plugin.js")) {
            $includeJS[] = "/ext/plugins/$plugin.js";
        }

        // css file
        if (file_exists("$extRoot/plugins/$plugin.css")) {
            $includeCSS[] = "/ext/plugins/$plugin.css";
        }
    }


    // iterate namespaces from include
    foreach ($include AS $namespace) {
        // find namespace css
        if (file_exists("$extRoot/$namespace/styles.css")) {
            $includeCSS[] = "/ext/$namespace/styles.css";
        }


        // find namespace classes js
        $classDir = "$extRoot/$namespace/classes";

        if (is_dir($classDir)) {
            $classFiles = array();

            $dh = opendir($classDir);
            while (($file = readdir($dh)) !== false) {
                if (substr($file, -3) == '.js') {
                    $classFiles[] = "/ext/$namespace/classes/$file";
                }
            }
            closedir($dh);

            // sort js includes by number of dots to ensure parents defined first
            usort($classFiles, create_function('$a,$b', 'return substr_count($a, ".") > substr_count($b, ".");'));

            // append to include list
            $includeJS = array_merge($includeJS, $classFiles);
        }
    }


    // build HTML
    // + CSS
    if (substr($version, 0, 1) == '3') {
        $return  = "<link rel='stylesheet' type='text/css' href='/js/frameworks/ext3/resources/css/ext-all.css' />\n";
    } else {
        $return  = "<link rel='stylesheet' type='text/css' href='/js/frameworks/ext/resources/css/ext-all.css' />\n";
    }

    foreach ($includeCSS AS $css) {
        $return .= "<link rel='stylesheet' type='text/css' href='$css' />\n";
    }

    // + JS
    $debug = ($debug ? '-debug' : '');

    if (substr($version, 0, 1) == '3') {
        $return .= "<script type='text/javascript' src='/js/frameworks/ext3/adapter/ext/ext-base.js'></script>\n";
        $return .= "<script type='text/javascript' src='/js/frameworks/ext3/ext-all$debug.js'></script>\n";
    } else {
        $return .= "<script type='text/javascript' src='/js/frameworks/ext/adapter/ext/ext-base.js'></script>\n";
        $return .= "<script type='text/javascript' src='/js/frameworks/ext/ext-all$debug.js'></script>\n";
    }

    $return .= "<script type='text/javascript' src='/ext/global.js'></script>\n";

    foreach ($includeJS AS $js) {
        $return .= "<script type='text/javascript' src='$js'></script>\n";
    }

    // + ext initialization
    $return .= "<script type='text/javascript'>\n";
    $return .= "\tExt.ns('$namespace');\n";
    if (substr($version, 0, 1) == '3') {
        $return .= "\tExt.BLANK_IMAGE_URL = '/js/frameworks/ext3/resources/images/default/s.gif';\n";
    } else {
        $return .= "\tExt.BLANK_IMAGE_URL = '/js/frameworks/ext/resources/images/default/s.gif';\n";
    }
    $return .= "\tExt.QuickTips.init();\n";


    $return .= "\tMICS.SiteName = \"".addslashes(Site::$Title)."\";\n";

    if (in_array('people', $include)) {
        $return .= "\tMICS.accountLevelValues = ".json_encode(Person::$RecordConfig['AccountLevelValues']).";\n";

        if (!empty($GLOBALS['Session']) && $GLOBALS['Session']->Person) {
            $return .= "\tMICS.sessionPerson = new people.PersonRecord(".json_encode($GLOBALS['Session']->Person->JsonTranslation).");\n";
        }
    }

    $return .= "</script>\n";


    return $return;
}
