<?php

/**
 * Obtain client id and secret by registering an application at https://api.slack.com/apps
 */

Emergence\Slack\API::$clientId = getenv('SLACK_CLIENT_ID');
Emergence\Slack\API::$clientSecret = getenv('SLACK_CLIENT_SECRET');
Emergence\Slack\API::$verificationToken = getenv('SLACK_VERIFICATION_TOKEN');

/**
 * Obtain under the **OAuth & Permissions** section while managing the application
 */

Emergence\Slack\API::$accessToken = getenv('SLACK_ACCESS_TOKEN');