/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.Revisions', {
    extend: 'Ext.grid.Panel'
    ,alias: 'widget.emergence-file-revisions'
    ,requires: [
        'Ext.grid.column.Template'
        ,'Ext.grid.column.Number'
        ,'Ext.util.Format'
    ]
    
    ,store: 'Revisions'
    ,componentCls: 'emergence-file-revisions'


    ,initComponent: function() {
        
        this.viewConfig = this.viewConfig || {};
        this.viewConfig.getRowClass = function(record) {
            return 'status-'+record.get('Status');
        };
        
        this.columns = [{
            header: 'Timestamp'
            ,dataIndex: 'Timestamp'
            ,renderer: function(mtime) {
                var now = new Date()
                    ,str = Ext.util.Format.date(mtime, 'g:i a');
                
                // add date if mtime > 24 hours ago
                if(now.getTime() - mtime.getTime() > 86400000) // 24 hr in ms
                {
                    str += ' &ndash; ';
                    str += Ext.util.Format.date(mtime, now.getYear() == mtime.getYear() ? 'M d' : 'M d Y');
                }
                
                return '<time datetime="'+Ext.util.Format.date(mtime, 'c')+'" title="'+Ext.util.Format.date(mtime, 'Y-m-d H:i:s')+'">'+str+'</time>';
            }
            ,width: 110
        },{
            header: 'Author'
            ,dataIndex: 'Author'
            ,flex: 1
            ,xtype: 'templatecolumn'
            ,tpl: [
                '<tpl for="Author">'
                    ,'<a href="/people/{Username}" title="{FirstName} {LastName} <{Email}>" target="_blank">{Username}</a>'
                ,'</tpl>'
            ]
        },{
            header: 'Size'
            ,dataIndex: 'Size'
            ,width: 60
            ,xtype: 'templatecolumn'
            ,tpl: [
                '<tpl if="Status==\'Deleted\'">'
                    ,'DELETED'
                ,'</tpl>'
                ,'<tpl if="Status!=\'Deleted\'">'
                    ,'<abbr title="{Size} bytes">{Size:fileSize}</abbr>'
                ,'</tpl>'
            ]
        }];
        
        this.callParent();    
    }
});