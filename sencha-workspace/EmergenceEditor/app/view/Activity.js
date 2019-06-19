/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext,Jarvus*/
Ext.define('EmergenceEditor.view.Activity', {
    extend: 'Ext.panel.Panel'
	,xtype: 'emergence-activity'
	,requires: [
		'Jarvus.util.MD5'
	]
	
	,title: 'Activity'
	,layout: 'fit'
	,dockedItems: [{
		xtype: 'toolbar'
		,dock: 'bottom'
		,items: [{
			xtype: 'button'
			,text: 'Refresh Activity'
			,action: 'refresh'
			,iconCls: 'refresh'
		},'->',{
			xtype: 'button'
			,text: 'Load Full History'
			,action: 'load-all'
			,iconCls: 'refresh'
		}]
	}]
		
	,items: [{
		xtype: 'dataview'
		,tpl: [
			'<section class="activity-feed">'
			,'<tpl for=".">'
				,'<article class="feed-item">'
					
					// user
                    ,'<tpl if="Author">'
    					,'<figure class="user">'
    						//,'<img src="/thumbnail/person/{Author.ID}/29x29xFFFFFF" width=29 height=29>'
    						,'<img src="' + Ext.BLANK_IMAGE_URL + '" style="background-image:url({[this.getAvatarUrl(values.Author, 58)]})" width=29 height=29>'
    						,'<figcaption>{Author.Username}</figcaption>'
    					,'</figure>'
                    ,'<tpl else>'
                        ,'<em class="user">anonymous</em>'
                    ,'</tpl>'

					// save actions (create, edit, create & edit)
					,'<tpl if="EventType == \'save\'">'
						,'<tpl if="revisionsCount == 1 && !revisions[0].AncestorID"><span class="action created">created</span></tpl>'
						,'<tpl if="revisions[0].AncestorID"><span class="action edited">edited</span></tpl>'
						,'<tpl if="revisionsCount &gt; 1 && !revisions[0].AncestorID"><span class="action created edited">created &amp; edited</span></tpl>' //create & edit
					,'</tpl>'
					
					// saved file
					,'<tpl if="EventType != \'delete\'">'
						,'<span class="file">'
							,'<span class="path">'
								,'<tpl if="Collection.ParentID">&hellip;</tpl>'
								,'/{Collection.Handle}/'
							,'</span>'
							,'<a class="filename" href="#/{CollectionPath}/{Handle}" title="/{CollectionPath}/{Handle}">{Handle}</a>'
							,'<tpl if="revisionsCount &gt; 1"><span class="revisions"><span class="count">{revisionsCount}</span> times</span></tpl>'
							,'<tpl if="FirstAncestorID && RevisionID"><a class="compare" href="#diff:[{FirstAncestorID},{RevisionID}]/{CollectionPath}/{Handle}">compare</a></tpl>'
						,'</span>'
					,'</tpl>'

					,'<tpl if="EventType == \'delete\'">'
						// delete action
						,'<span class="action deleted">deleted</span>'
                        
						// deleted file
						,'<tpl if="values.files.length == 1">'
						,'<tpl for="files">'
							,'<span class="file">'
								,'<span class="path">'
									,'<tpl if="Collection.ParentID">&hellip;</tpl>'
									,'/{Collection.Handle}/'
								,'</span>'
								,'<a class="filename" href="#/{CollectionPath}/{Handle}" title="/{CollectionPath}/{Handle}">{Handle}</a>'
							,'</span>'
						,'</tpl>'
						,'</tpl>'
						
						// deleted files
						,'<tpl if="values.files.length != 1">'
							,'<span class="file"><span class="count">{[values.files.length]}</span> files</span>'
						,'</tpl>'
					,'</tpl>'
					
					// timestamp
					,'<time class="timestamp">'
						,'<tpl if="FirstTimestamp && FirstTimestamp.getTime() != Timestamp.getTime()">'
							,'{FirstTimestamp:date("M j, g:i a")}&thinsp;&ndash;&thinsp;{Timestamp:date("g:i a")}'
						,'</tpl>'
						,'<tpl if="!FirstTimestamp || FirstTimestamp.getTime() == Timestamp.getTime()">'
							,'{Timestamp:date("M j, g:i a")}'
						,'</tpl>'
					,'</time>'

				,'</article>'
			,'</tpl>'
			,'</section>'
			,{
				getAvatarUrl: function(userData, size) {
					if (userData && userData.PrimaryPhotoID) {
						return '/thumbnail/'+userData.PrimaryPhotoID+'/'+size+'x'+size;
					}
					
					return '//www.gravatar.com/avatar/'+Jarvus.util.MD5.cachedHash(((userData && userData.Email) || '').toLowerCase())+'?s='+size+'&r=g&d=retro';
				}
			}
		]
		,itemSelector: 'article'
		,emptyText: 'No activity'
		,store: 'ActivityStream'
		,autoScroll: true
	}]
	
});