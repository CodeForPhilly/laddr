<?php

namespace Emergence\GitHub;

use Exception;
use Site;
use Emergence\EventBus;


class Connector extends \Emergence\Connectors\AbstractConnector
{
    public static $webhookSecret;

    public static function handleRequest($action = null)
    {
        switch ($action ?: $action = static::shiftPath()) {
            case 'link-user':
                return static::handleLinkUserRequest();
            case 'unlink-user':
                return static::handleUnlinkUserRequest();
            case 'webhooks':
                return static::handleWebhooksRequest();
            case 'oauth':
                return static::handleOAuthRequest();
            default:
                return parent::handleRequest($action);
        }
    }

    public static function handleLinkUserRequest()
    {
        $GLOBALS['Session']->requireAuthentication();

        $stateToken = sha1(microtime().rand().$_SERVER['REMOTE_ADDR']);
        setcookie('gh-state', $stateToken, time() + 600, '/connectors/github');

        Site::redirect('https://github.com/login/oauth/authorize', [
            'client_id' => API::$clientId,
            'redirect_uri' => (Site::getConfig('ssl') ? 'https' : 'http').'://'.$_SERVER['HTTP_HOST'].'/connectors/github/oauth/link-user',
            'scope' => 'user repo',
            'state' => $stateToken
        ]);
    }

    public static function handleUnlinkUserRequest()
    {
        $GLOBALS['Session']->requireAuthentication();

        if ($_SERVER['REQUEST_METHOD'] != 'POST') {
            return static::respond('confirm', [
                'question' => _('Are you sure you want to unlink your GitHub user account?')
            ]);
        }

        $GLOBALS['Session']->Person->GitHubToken = null;
        $GLOBALS['Session']->Person->save();

        return static::respond('message', [
            'message' => 'Your GitHub account has been unlinked from your user profile successfully'
        ]);
    }

    public static function handleWebhooksRequest()
    {
        if ($_SERVER['REQUEST_METHOD'] != 'POST') {
            throw new Exception('request method must be POST');
        }

        if ($_SERVER['HTTP_CONTENT_TYPE'] != 'application/json') {
            throw new Exception('request content-type must be application/json');
        }

        if (!$rawData = file_get_contents('php://input')) {
            throw new Exception('request body missing');
        }

        if (!$data = json_decode($rawData, true)) {
            throw new Exception('failed to parse request body');
        }

        if (static::$webhookSecret) {
            if (empty($data['secret'] || $data['secret'] != static::$webhookSecret)) {
                if (!extension_loaded('hash')) {
                    throw new Exception('hash extension not available');
                }

                if (empty($_SERVER['HTTP_X_HUB_SIGNATURE'])) {
                    throw new Exception('signature header missing');
                }

                list($algo, $hash) = explode('=', $_SERVER['HTTP_X_HUB_SIGNATURE'], 2) + ['', ''];

                if (!in_array($algo, hash_algos())) {
                    throw new Exception('unsupported hash algorithm: ' . $algo);
                }

                if ($hash != hash_hmac($algo, $rawData, static::$webhookSecret)) {
                    throw new Exception('invalid signature');
                }
            }
        }

        EventBus::fireEvent($_SERVER['HTTP_X_GITHUB_EVENT'], __NAMESPACE__, $data);

        return static::respond('webhookReceived', ['success' => true], 'json');
    }

    public static function handleOAuthRequest()
    {
        if (empty($_GET['code'])) {
            throw new Exception('code missing');
        }

        if (empty($_GET['state'])) {
            throw new Exception('state missing');
        }

        if (empty($_COOKIE['gh-state']) || $_GET['state'] != $_COOKIE['gh-state']) {
            return static::throwInvalidRequestError('The returning GitHub state token does not match the one you were sent out with, please try again');
        }

        if (static::peekPath() == 'link-user') {
            $GLOBALS['Session']->requireAuthentication();
        }

        setcookie('gh-state', '', time() - 3600, '/connectors/github');

        $responseData = API::request('https://github.com/login/oauth/access_token', [
            'skipAuth' => true,
            'headers' => [
                'Accept: application/json'
            ],
            'post' => [
                'client_id' => API::$clientId,
                'client_secret' => API::$clientSecret,
                'code' => $_GET['code']
            ]
        ]);

        if (empty($responseData['access_token'])) {
            throw new Exception('access_token not returned by GitHub');
        }

        if (static::peekPath() == 'link-user') {
            $GLOBALS['Session']->Person->GitHubToken = $responseData['access_token'];
            $GLOBALS['Session']->Person->save();

            return static::respond('message', [
                'message' => 'Your GitHub account has been linked to your user profile successfully'
            ]);
        }

        return static::respond('message', [
            'message' => 'Access token issued by GitHub: ' . $responseData['access_token']
        ]);
    }
}
