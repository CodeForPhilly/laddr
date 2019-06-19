/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.store.ActivityStream', {
    extend: 'Ext.data.Store'
    ,alias: 'store.activitystream'
    //,autoLoad: true
    ,model: 'EmergenceEditor.model.ActivityEvent'
    ,proxy: {
        type: 'ajax'
        ,url: '/editor/activity'
        ,reader: {
            type: 'json'
            ,root: 'data'
        }
    }
});