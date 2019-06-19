/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.window.Import', {
    extend: 'Ext.window.Window'
    ,requires: ['Ext.form.Label']
    ,alias: 'widget.emergence-import-window'
    //,stateId: 'emergence-import-window'
    ,title: 'Import'
    ,width: 350
    ,height: 200
    ,layout: {
        type: 'hbox'
        ,align: 'middle'
    }
    ,items: [
		{
			xtype: 'label'
			,text: 'Drag and Drop Archive Here to Import'
			,margins: '0 0 0 60'
		}
    ]
    ,defaults: {
        anchor: '100%'
    }
});