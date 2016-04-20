{$hostname = Site::getConfig('primary_hostname')}
{capture assign=subject}Welcome to {$hostname}{/capture}
<html>
    <body>
        <p>Hi {$User->FirstName},</p>
        <p>Welcome to <a href="http://{$hostname}">{$hostname}</a>! Keep this information for your record:</p>

        <table border="0">
            <tr><th align="right">Username:</th><td>{$User->Username}</td></tr>
            <tr><th align="right">Registered Email:</th><td><a href="mailto:{$User->Email}">{$User->Email}</a></td></tr>
            <tr><th align="right">Login URL:</th><td><a href="http://{$hostname}/login">http://{$hostname}/login</a></td></tr>
        </table>

        <p>Got a few minutes to spare? <a href="http://{$hostname}/profile">Upload a photo and fill out your profile</a></p>
        <ul>
            <li><a href="http://{$hostname}/profile">Fill out your profile and upload a photo</a></li>
            <li>Take <a href="https://codeforphilly.typeform.com/to/UnDAvy" target="_blank">this</a> short survey to let us know about your experience so far.</li>
        </ul>
        <p><em>
            Photos taken during Code for Philly events and meetups may be used for promotional purposes. By attending a Code for Philly event,
            you grant Code for Philly the right to use the photographs or their likenesses in Code for Philly publications, video, websites,
            news media, social media, or other recruitment or promotional materials. Should you have any objection to the use of your photograph,
            please see a staff member or contact us at <a href="mailto:hello@codeforphilly.org?subject=Photography">hello@codeforphilly.org</a>.
        </em></p>
    </body>
</html>
