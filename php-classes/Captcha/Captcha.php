<?php
namespace Captcha;

use Captcha\Response;
use Captcha\Exception;

/**
 * Copyright (c) 2015, Aleksey Korzun <aleksey@webfoundation.net>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are those
 * of the authors and should not be interpreted as representing official policies,
 * either expressed or implied, of the FreeBSD Project.
 *
 * Proper library for reCaptcha service
 *
 * @author Aleksey Korzun <aleksey@webfoundation.net>
 * @see http://www.google.com/recaptcha/intro/index.html
 * @throws Exception
 * @package library
 */
class Captcha
{
    /**
     * reCaptcha's API server
     *
     * @var string
     */
    const SERVER = '//www.google.com/recaptcha/api';

    /**
     * reCaptcha's verify server
     *
     * @var string
     */
    const VERIFY_SERVER = 'www.google.com';

    /**
     * The Remote IP Address
     *
     * @var string
     */
    protected $remoteIp;

    /**
     * Private key
     *
     * @var string
     */
    protected $privateKey;
    public static $captchaPrivateKey;
    /**
     * Public key
     *
     * @var string
     */
    protected $publicKey;
    public static $captchaPublicKey;
    /**
     * Custom error message to return
     *
     * @var string
     */
    protected $error;

    /**
     * The theme we use. The default theme is light, but you can change it using setTheme()
     *
     * @var string
     * @see https://developers.google.com/recaptcha/docs/display
     */
    protected $theme = 'light';

    /**
     * Type of widget to display. The default type is image.
     *
     * @var string
     * @see https://developers.google.com/recaptcha/docs/display
     */
    protected $type = 'image';

    /**
     * Size of widget to display. The default type is normal.
     *
     * @var string
     * @see https://developers.google.com/recaptcha/docs/display
     */
    protected $size = 'normal';

    /**
     * Optional tab index for input elements within the widget.
     *
     * @var int
     * @see https://developers.google.com/recaptcha/docs/display
     */
    protected $tabIndex = 0;

    /**
     * An array of supported themes.
     *
     * @var string[]
     * @see https://developers.google.com/recaptcha/docs/display
     */
    protected static $themes = array(
        'light',
        'dark'
    );

    /**
     * An array of supported data types.
     *
     * @var string[]
     * @see https://developers.google.com/recaptcha/docs/display
     */
    protected static $types = array(
        'image',
        'audio'
    );

    /**
     * An array of supported data sizes.
     *
     * @var string[]
     * @see https://developers.google.com/recaptcha/docs/display
     */
    protected static $sizes = array(
        'normal',
        'compact'
    );

    /**
     * Set public key
     *
     * @param string $key
     * @return reCaptcha
     */
    public function setPublicKey($key)
    {
        $this->publicKey = $key;
        return $this;
    }

    /**
     * Retrieve currently set public key
     *
     * @return string
     */
    public function getPublicKey()
    {
        return $this->publicKey;
    }

    /**
     * Set private key
     *
     * @param string $key
     * @return reCaptcha
     */
    public function setPrivateKey($key)
    {
        $this->privateKey = $key;
        return $this;
    }

    /**
     * Retrieve currently set private key
     *
     * @return string
     */
    public function getPrivateKey()
    {
        return $this->privateKey;
    }

    /**
     * Set remote IP
     *
     * @param string $ip
     * @return reCaptcha
     */
    public function setRemoteIp($ip)
    {
        $this->remoteIp = $ip;
        return $this;
    }

    /**
     * Get remote IP
     *
     * @return string
     */
    public function getRemoteIp()
    {
        if ($this->remoteIp) {
            return $this->remoteIp;
        }

        if (isset($_SERVER['REMOTE_ADDR'])) {
            return $_SERVER['REMOTE_ADDR'];
        }

        return null;
    }

    /**
     * Set error string
     *
     * @param string $error
     * @return reCaptcha
     */
    public function setError($error)
    {
        $this->error = (string) $error;
        return $this;
    }

    /**
     * Retrieve currently set error
     *
     * @return string
     */
    public function getError()
    {
        return $this->error;
    }

    /**
     * Generates reCaptcha form to output to your end user
     *
     * @throws Exception
     * @return string
     */
    public function html()
    {
        if (!$this->getPublicKey()) {
            throw new Exception('You must set public key provided by reCaptcha');
        }

        return
            '<script src="https://www.google.com/recaptcha/api.js" async defer></script>' .
            '<div class="g-recaptcha" data-sitekey="' . $this->getPublicKey() . '" data-theme="' . $this->theme .
            '" data-type="' . $this->type . '" data-size="' . $this->size . '" data-tabIndex="' . $this->tabIndex .
            '"></div>';
    }

    /**
     * Checks and validates user's response
     *
     * @param bool|string $captchaResponse Optional response string. If empty, value from $_POST will be used
     * @throws Exception
     * @return Response
     */
    public function check($captchaResponse = false)
    {
        if (!$this->getPrivateKey()) {
            throw new Exception('You must set private key provided by reCaptcha');
        }

        // Skip processing of empty data
        if (!$captchaResponse) {
            if (isset($_POST['g-recaptcha-response'])) {
                $captchaResponse = $_POST['g-recaptcha-response'];
            }
        }

        // Create a new response object
        $response = new Response();

        // Discard SPAM submissions
        if (strlen($captchaResponse) == 0) {
            $response->setValid(false);
            $response->setError('Incorrect-captcha-sol');
            return $response;
        }

        $process = $this->process(
            array(
                'secret' => $this->getPrivateKey(),
                'remoteip' => $this->getRemoteIp(),
                'response' => $captchaResponse
            )
        );

        $answer = @json_decode($process, true);

        if (is_array($answer) && isset($answer['success']) && $answer['success']) {
            $response->setValid(true);
        } else {
            $response->setValid(false);
            $response->setError(serialize($answer));
        }

        return $response;
    }

    /**
     * Make a signed validation request to reCaptcha's servers
     *
     * @throws Exception
     * @param array $parameters
     * @return string
     */
    protected function process($parameters)
    {
        // Properly encode parameters
        $parameters = http_build_query($parameters);

        // Make validation request
        $response = @file_get_contents('https://' . self::VERIFY_SERVER . '/recaptcha/api/siteverify?' . $parameters);
        if (!$response) {
            throw new Exception('Unable to communicate with reCaptcha servers. Response: ' . serialize($response));
        }

        return $response;
    }

    /**
     * Returns a boolean indicating if a theme name is valid
     *
     * @param string $theme
     * @return bool
     */
    protected static function isValidTheme($theme)
    {
        return (bool)in_array($theme, self::$themes);
    }

    /**
     * Returns a boolean indicating if a widget size is valid
     *
     * @param string $size
     * @return bool
     */
    protected static function isValidSize($size)
    {
        return (bool)in_array($size, self::$sizes);
    }

    /**
     * Returns a boolean indicating if a widget type is valid
     *
     * @param string $type
     * @return bool
     */
    protected static function isValidType($type)
    {
        return (bool)in_array($type, self::$types);
    }

    /**
     * Set widget theme
     *
     * @param string $theme
     * @return Captcha
     * @throws Exception
     * @see https://developers.google.com/recaptcha/docs/customization
     */
    public function setTheme($theme)
    {
        if (!self::isValidTheme($theme)) {
            throw new Exception(
                'Theme ' . $theme . ' is not valid. Please use one of [' . join(', ', self::$themes) . ']'
            );
        }

        $this->theme = (string)$theme;

        return $this;
    }

    /**
     * Set widget size
     *
     * @param string $size
     * @return Captcha
     * @throws Exception
     * @see https://developers.google.com/recaptcha/docs/customization
     */
    public function setSize($size)
    {
        if (!self::isValidSize($size)) {
            throw new Exception(
                'Size ' . $size . ' is not valid. Please use one of [' . join(', ', self::$size) . ']'
            );
        }

        $this->size = (string)$size;

        return $this;
    }

    /**
     * Set widget type
     *
     * @param string $type
     * @return Captcha
     * @throws Exception
     * @see https://developers.google.com/recaptcha/docs/customization
     */
    public function setType($type)
    {
        if (!self::isValidSize($type)) {
            throw new Exception(
                'Type ' . $type . ' is not valid. Please use one of [' . join(', ', self::$type) . ']'
            );
        }

        $this->type = (string)$type;

        return $this;
    }

    /**
     * Set widgets tab index
     *
     * @param int $tabIndex
     * @return Captcha
     * @throws Exception
     * @see https://developers.google.com/recaptcha/docs/customization
     */
    public function setTabIndex($tabIndex)
    {
        if (!is_numeric($tabIndex)) {
            throw new Exception(
                'Tab index of ' . $tabIndex . ' is not valid.'
            );
        }

        $this->tabIndex = (int)$tabIndex;

        return $this;
    }
}

