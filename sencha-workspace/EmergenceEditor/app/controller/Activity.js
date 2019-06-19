/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.controller.Activity', {
    extend: 'Ext.app.Controller'
    
    ,views: ['Activity']
    ,stores: ['ActivityStream']
    ,models: ['ActivityEvent']
    
    ,refs: [{
        ref: 'activityStream'
        ,selector: 'emergence-activity dataview'
    }]
    
    ,onLaunch: function() {
        //console.info('Emergence.Editor.controller.Activity.onLaunch()');
        var activityStream = this.getActivityStream();
        if(activityStream)
        {
            if(activityStream.isVisible())
                this.loadActivity();
            else
               activityStream.on('activate', this.loadActivity, this, {single: true});
        }
    }
    
    ,init: function() {
        //console.info('Emergence.Editor.controller.Activity.init()');
        
        // Start listening for events on views
        this.control({
            'emergence-activity button[action=refresh]': {
                click: this.loadActivity
            }
            ,'emergence-activity button[action=load-all]': {
                click: this.loadAllActivity
            }
        });
    }
    
    
    ,loadActivity: function() {
        this.getActivityStream().getStore().load();
    }
    
    ,loadAllActivity: function() {
        this.getActivityStream().getStore().load({
            url: '/editor/activity/all'        
        });
    }
});