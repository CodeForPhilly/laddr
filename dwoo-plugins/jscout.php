<?php

function Dwoo_Plugin_jscout(Dwoo_Core $dwoo, $lib = '/jslib', $use = array(), $debug = false, $writeTemplateVars = false, $useReady = false)
{
    // process lib
    if (empty($lib) || ($lib[0]!='/')) {
        throw new Exception('jscout loader: lib must be an absolute http path from the server root starting with /');
    } else {
        $lib = explode('/', trim($lib,'/'));
    }

    // process use
    if (is_string($use)) {
        $use = preg_split('/\s*,\s*/', $use);
    }
    if (!is_array($use)) {
        throw new Exception('jscout loader: use must be array or comma-delimited string');
    }

    // allow override of debug via GET/POST
    if (!empty($_REQUEST['jsdebug'])) {
        $debug = true;
    }


    // ext3 source
    $return = '<script src="/jslib/ext3/adapter/ext/ext-base'.($debug?'-debug':'').'.js"></script>'.PHP_EOL;
    $return .= '<script src="/jslib/ext3/ext-all'.($debug?'-debug':'').'.js"></script>'.PHP_EOL;

    // jScout source
    $return .= '<script src="/jslib/jScout.js"></script>'.PHP_EOL;

    // Ext and jScout setup
    $return .= '<script>'.PHP_EOL;
    $return .= 'Ext.BLANK_IMAGE_URL="/jslib/ext3/resources/images/default/s.gif";'.PHP_EOL;
    $return .= 'jScout.libRoot='.json_encode($lib).';'.PHP_EOL;
    $return .= "jScout.use('MICS',function(){\n\t";
    $return .= "	MICS.SessionCookie = \"".addslashes(Session::$cookieName)."\";\n";
    $return .= "	MICS.SiteName = \"".addslashes(MICS::$SiteName)."\";\n";
    $return .= "	MICS.User = ".json_encode($_SESSION['User'] ? $_SESSION['User']->getData() : false).";\n";
    if ($writeTemplateVars) {
        $return .= '	MICS.responseVars='.json_encode(JSON::translateObjects($dwoo->data)).";\n";
    }

    if (!empty($use)) {
        if (empty($useReady)) {
            $return .= 'jScout.use('.json_encode($use).');'.PHP_EOL;
        } else {
            $return .= 'jScout.use('.json_encode($use).', function() {'.$useReady.'});'.PHP_EOL;
        }
    }

    $return .= "});";

    $return .= '</script>'.PHP_EOL;

    // ext3 stylesheet
    $return .= '<link rel="stylesheet" type="text/css" href="/jslib/ext3/resources/css/ext-all.css" />'.PHP_EOL;

    return $return;
}
