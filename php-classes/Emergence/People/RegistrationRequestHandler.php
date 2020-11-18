<?php

namespace Emergence\People;

use PasswordToken;
use Emergence\Mailer\Mailer;
use Emergence\EventBus;

class RegistrationRequestHandler extends \RequestHandler
{
    // configurables
    public static $enableRegistration = true;
    public static $createUser;
    public static $onRegisterComplete;
    public static $applyRegistrationData;
    public static $registrationFields = array(
        'FirstName'
        ,'LastName'
        ,'Gender'
        ,'BirthDate'
        ,'Username'
        ,'Password'
        ,'Email'
        ,'Phone'
        ,'Location'
        ,'About'
    );

    // RequestHandler
    public static $responseMode = 'html';
    public static $userResponseModes = array(
        'application/json' => 'json'
    );

    public static function handleRequest()
    {
        switch ($action = static::shiftPath()) {
            case 'recover':
                return static::handleRecoverPasswordRequest();
            case '':
            case false:
                return static::handleRegistrationRequest();
            default:
                return static::throwNotFoundError();
        }
    }

    public static function handleRegistrationRequest($overrideFields = array())
    {
        if (!empty($_SESSION['User'])) {
            return static::throwError('You are already logged in. Please log out if you need to register a new account.');
        }

        if (!static::$enableRegistration) {
            return static::throwError('Sorry, self-registration is not currently available. Please contact an administrator.');
        }

        $filteredRequestFields = array_intersect_key($_REQUEST, array_flip(static::$registrationFields));
        $additionalErrors = array();

        if (is_callable(static::$createUser)) {
            $User = call_user_func_array(static::$createUser, array(&$filteredRequestFields, &$additionalErrors));
        } else {
            $className = User::getStaticDefaultClass();
            $User = new $className();
        }

        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            // save person fields
            $User->setFields(array_merge($filteredRequestFields, $overrideFields));

            if (!empty($filteredRequestFields['Password'])) {
                $User->setClearPassword($filteredRequestFields['Password']);
            }

            // additional checks
            if (empty($filteredRequestFields['Password']) || (strlen($filteredRequestFields['Password']) < $User::$minPasswordLength)) {
                $additionalErrors['Password'] = 'Password must be at least '.$User::$minPasswordLength.' characters long.';
            } elseif (empty($_REQUEST['PasswordConfirm']) || ($filteredRequestFields['Password'] != $_REQUEST['PasswordConfirm'])) {
                $additionalErrors['PasswordConfirm'] = 'Please enter your password a second time for confirmation.';
            }

            // configurable hook
            if (is_callable(static::$applyRegistrationData)) {
                call_user_func_array(static::$applyRegistrationData, array($User, $filteredRequestFields, &$additionalErrors));
            }

            EventBus::fireEvent('beforeRegister', self::class, array(
                'User' => $User,
                'requestData' => $_REQUEST,
                'additionalErrors' => &$additionalErrors
            ));

            // validate
            if ($User->validate() && empty($additionalErrors)) {
                // save store
                $User->save();

                // upgrade session
                $GLOBALS['Session'] = $GLOBALS['Session']->changeClass('UserSession', array(
                    'PersonID' => $User->ID
                ));

                // send welcome email
                Mailer::sendFromTemplate($User->EmailRecipient, 'registerComplete', array(
                    'User' => $User,
                    'registrationData' => $filteredRequestFields
                ));

                if (is_callable(static::$onRegisterComplete)) {
                    call_user_func(static::$onRegisterComplete, $User, $filteredRequestFields);
                }

                EventBus::fireEvent('registerComplete', self::class, array(
                    'User' => $User,
                    'requestData' => $_REQUEST
                ));

                return static::respond('registerComplete', array(
                    'success' => true
                    ,'data' => $User
                ));
            }

            if (count($additionalErrors)) {
                $User->addValidationErrors($additionalErrors);
            }

            // fall through back to form if validation failed
        } else {
            // apply overrides to phantom
            $User->setFields($overrideFields);
        }

        return static::respond('register', array(
            'success' => false
            ,'data' => $User
        ));
    }


    public static function handleRecoverPasswordRequest()
    {
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $userClass = User::getStaticDefaultClass();

            if (empty($_REQUEST['username'])) {
                $error = 'Please provide either your username or email address to reset your password.';
            } elseif (!($User = $userClass::getByUsername($_REQUEST['username'])) && !($User = $userClass::getByEmail($_REQUEST['username']))) {
                $error = 'No account is currently registered for that username or email address.';
            } elseif (!$User->Email) {
                $error = 'Unforunately, there is no email address on file for this account. Please contact an administrator.';
            } else {
                $Token = PasswordToken::create(array(
                    'CreatorID' => $User->ID
                ), true);

                $Token->sendEmail($User->EmailRecipient);

                return static::respond('recoverPasswordComplete', array(
                    'success' => true
                ));
            }
        }

        return static::respond('recoverPassword', array(
            'success' => empty($error),
            'error' => isset($error) ? $error : false
        ));
    }
}
