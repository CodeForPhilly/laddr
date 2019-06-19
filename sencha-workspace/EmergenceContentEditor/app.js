/*
 * This file is generated and updated by Sencha Cmd. You can edit this file as
 * needed for your application, but these edits will have to be merged by
 * Sencha Cmd when upgrading.
 */
Ext.application({
    name: 'EmergenceContentEditor',

    extend: 'EmergenceContentEditor.Application',

    requires: [
        'Emergence.util.API',
        'Emergence.cms.view.DualView',
        'Ext.container.Viewport'
    ],

    //-------------------------------------------------------------------------
    // Most customizations should be made to EmergenceContentEditor.Application. If you need to
    // customize this file, doing so below this section reduces the likelihood
    // of merge conflicts when upgrading to new versions of Sencha Cmd.
    //-------------------------------------------------------------------------

    launch: function() {
        var pageParams = Ext.Object.fromQueryString(location.search),
            siteEnv = window.SiteEnvironment || {},
            API = Emergence.util.API,
            viewportEl = Ext.get('app-viewport'),
            editorConfig = {},
            mainView;

        // configure editor
        if (siteEnv.cmsComposers) {
            editorConfig.composers = siteEnv.cmsComposers;
        }

        if (siteEnv.cmsContent) {
            editorConfig.contentRecord = siteEnv.cmsContent;
        }

        // instantiate editor
        mainView = Ext.create('Emergence.cms.view.DualView', {
            editorConfig: editorConfig
        });

        // allow API host to be overridden via apiHost param
        if (pageParams.apiHost) {
            API.setHost(pageParams.apiHost.replace(/(^[a-zA-Z]+:\/\/)?([^/]+).*/, '$2'));
            API.setUseSSL(!!pageParams.apiSSL);
        }

        // load DualView UI into viewport element or created viewport container
        if (viewportEl) {
            viewportEl.empty();
            mainView.render(viewportEl);

            viewportEl.on('resize', function(el, info) {
                mainView.setWidth(info.contentWidth);
            });
        } else {
            Ext.create('Ext.container.Viewport', {
                layout: 'fit',
                items: mainView
            });
        }

        this.callParent();
    }
});
