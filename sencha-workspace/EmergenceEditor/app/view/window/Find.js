/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.window.Find', {
    extend: 'Ext.window.Window'
    ,requires: ['Ext.form.Panel','Ext.form.field.Text','Ext.form.field.Checkbox']
    ,alias: 'widget.emergence-find-window'
    
    ,stateId: 'emergence-find-window'
    ,title: 'Find Text'
    ,width: 320
    ,height: 200
    ,layout: 'anchor'
    ,defaults: {
        anchor: '100%'
    }
    ,items: [
        {
            xtype: 'form'
            ,defaultType: 'textfield'
            ,items: [{
                fieldLabel: 'Find'
                ,name: 'find'
            },{
                fieldLabel: 'Case sensitive'
                ,name: 'casesens'
                ,xtype: 'checkboxfield'   
            },{
                fieldLabel: 'Whole words only'
                ,name: 'wholewords'
                ,xtype: 'checkboxfield'   
            },{
                fieldLabel: 'Regular expression'
                ,name: 'regex'
                ,xtype: 'checkboxfield'   
            }]
            ,buttons: [{
                text: 'Find'
                ,action: 'find'
            },{
                text: 'Find Next'
                ,action: 'next'
            },{
                text: 'Find Previous'
                ,action: 'previous'
            }]
        }       
    ]
});