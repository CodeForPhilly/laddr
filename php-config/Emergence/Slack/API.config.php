<?php

/**
 * Obtain client id and secret by registering an application at https://api.slack.com/apps
 */

Emergence\Slack\API::$clientId = '';
Emergence\Slack\API::$clientSecret = '';
Emergence\Slack\API::$verificationToken = '';

/**
 * Obtain under the **OAuth & Permissions** section while managing the application
 */

Emergence\Slack\API::$accessToken = '';