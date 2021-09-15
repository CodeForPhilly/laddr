<?php

/**
 * Obtain client id and secret by registering an application at https://github.com/settings/applications/new
 *
 * - Enter `http://{$primaryHostname}/connectors/github/oauth` for "Authorization callback URL"
 */

Emergence\GitHub\API::$clientId = getenv('GITHUB_CLIENT_ID');
Emergence\GitHub\API::$clientSecret = getenv('GITHUB_CLIENT_SECRET');

/**
 * Optional: configure a site-wide access token for system operations
 */
Emergence\GitHub\API::$accessToken = getenv('GITHUB_ACCESS_TOKEN');