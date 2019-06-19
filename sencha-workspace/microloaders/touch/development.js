/* jshint undef: true, unused: true, browser: true, quotmark: single, curly: true */
/* global Ext */

/**
 * Minimal Sencha Touch microloader for emergence
 * Author: Chris Alfano <chris@jarv.us>
 */
(function(global) {
    var Ext = global.Ext = global.Ext || {};

    Ext.filterPlatform = function(platform) {
        var profileMatch = false,
            ua = navigator.userAgent,
            j, jln;

        platform = [].concat(platform);

        function isPhone(ua) {
            var isMobile = /Mobile(\/|\s)/.test(ua);

            // Either:
            // - iOS but not iPad
            // - Android 2
            // - Android with "Mobile" in the UA

            return /(iPhone|iPod)/.test(ua) ||
                      (!/(Silk)/.test(ua) && (/(Android)/.test(ua) && (/(Android 2)/.test(ua) || isMobile))) ||
                      (/(BlackBerry|BB)/.test(ua) && isMobile) ||
                      /(Windows Phone)/.test(ua);
        }

        function isTablet(ua) {
            return !isPhone(ua) && (/iPad/.test(ua) || /Android|Silk/.test(ua) || /(RIM Tablet OS)/.test(ua) ||
                (/MSIE 10/.test(ua) && /; Touch/.test(ua)));
        }

        // Check if the ?platform parameter is set in the URL
        var paramsString = window.location.search.substr(1),
            paramsArray = paramsString.split("&"),
            params = {},
            testPlatform, i;

        for (i = 0; i < paramsArray.length; i++) {
            var tmpArray = paramsArray[i].split("=");
            params[tmpArray[0]] = tmpArray[1];
        }

        testPlatform = params.platform;
        if (testPlatform) {
            return platform.indexOf(testPlatform) != -1;
        }

        for (j = 0, jln = platform.length; j < jln; j++) {
            switch (platform[j]) {
                case 'phone':
                    profileMatch = isPhone(ua);
                    break;
                case 'tablet':
                    profileMatch = isTablet(ua);
                    break;
                case 'desktop':
                    profileMatch = !isPhone(ua) && !isTablet(ua);
                    break;
                case 'ios':
                    profileMatch = /(iPad|iPhone|iPod)/.test(ua);
                    break;
                case 'android':
                    profileMatch = /(Android|Silk)/.test(ua);
                    break;
                case 'blackberry':
                    profileMatch = /(BlackBerry|BB)/.test(ua);
                    break;
                case 'safari':
                    profileMatch = /Safari/.test(ua) && !(/(BlackBerry|BB)/.test(ua));
                    break;
                case 'chrome':
                    profileMatch = /Chrome/.test(ua);
                    break;
                case 'ie10':
                    profileMatch = /MSIE 10/.test(ua);
                    break;
                case 'windows':
                    profileMatch = /MSIE 10/.test(ua) || /Trident/.test(ua);
                    break;
                case 'tizen':
                    profileMatch = /Tizen/.test(ua);
                    break;
                case 'firefox':
                    profileMatch = /Firefox/.test(ua);
            }
            if (profileMatch) {
                return true;
            }
        }
        return false;
    };
})(this);