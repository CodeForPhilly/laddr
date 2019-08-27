<?php

/**
 * Obtain client id and secret by registering an application at https://secure.meetup.com/meetup_api/oauth_consumers/
 *
 * - Enter `http://{$primaryHostname}/connectors/meetup/oauth` for "Authorization callback URL"
 */

Emergence\Meetup\API::$clientId = '';
Emergence\Meetup\API::$clientSecret = '';

/**
 * Optional: configure a site-wide access token for system operations
 */
Emergence\Meetup\API::$accessToken = '';