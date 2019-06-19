/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.SearchResults', {
    extend: 'Ext.view.View'
	,alias: 'widget.search-results'
	,layout: 'fit'

    ,store: 'SiteSearch'
	,tpl: [
		'<section class="activity-feed">'
		,'<tpl for="results">'
			,'<article class="feed-item">'
				,'<span class="file">'
					,'<a class="filename" href="#/{File.FullPath}:{line}" title="/{File.FullPath}:{line}">{File.Handle}</a>'
				,'</span>'
				,'Line {line}<pre>{[this.formatMatch(values.result, parent.query)]}</pre>'
			,'</article>'
		,'</tpl>'
		,'</section>'
        ,{
            formatMatch: function(result, query) {
                var regexp = new RegExp(query)
                    ,match = result.match(regexp)
                    ,matchIndex = result.search(regexp)
                    ,htmlEncode = Ext.util.Format.htmlEncode;

                if (matchIndex >= 0) {
                    return htmlEncode(result.substring(0, matchIndex)) + '<mark>' + htmlEncode(match[0]) + '</mark>' + htmlEncode(result.substr(matchIndex + match[0].length));
                } else {
                    return htmlEncode(result);
                }
            }
        }
	]
	,itemSelector: 'article'
	,emptyText: 'Nothing found.'
	//,store: 'SiteSearch'
	,autoScroll: true
    ,collectData : function(records, startIndex) {
        return {
            query: this.getStore().getProxy().extraParams.q
            ,results: this.callParent(arguments)
        };
    }
});