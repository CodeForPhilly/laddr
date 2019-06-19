/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/

/* @Author Henry Paradiz <henry@jarv.us>	
 * 
 *	SimpleCodeViewer
 *
 *	Ext4 reconstruction of Ext 3.2.1's Ext.ux.CodeViewer published online at <http://www.sencha.com/files/blog/old/blog/wp-content/uploads/js-diff-blog/codeViewer.js>
 *
 */

Ext.define('EmergenceEditor.view.SimpleCodeViewer', {
    extend: 'Ext.panel.Panel'
	,alias: 'widget.emergence-diff-viewer'
	,layout: {
		type: 'hbox'
		,align: 'stretch'
	} 
    ,listeners: {
        afterrender: {
            single: true
            ,delay: 10
            ,fn: function(tab, eopts){
                var codeViewerA = tab.items.get(0).items.get(0),
                codeViewerB = tab.items.get(1).items.get(0),
                syncScrollBars = function(e) {
                    var scrollTop = this.dom.scrollTop;
                    codeViewerA.el.dom.scrollTop = scrollTop;
                    codeViewerB.el.dom.scrollTop = scrollTop;
                };
                codeViewerA.el.on("scroll", syncScrollBars);
                codeViewerB.el.on("scroll", syncScrollBars);
                
                tab.initDiffViewer();       
            }
        }
    }
	,tbar: [{	
        xtype: 'button'
        ,text: 'Edit Mode'
        ,enableToggle: true
        ,toggleHandler: function(button, toggled) {
            // Switch between showing editors and viewers
            
            var panel = this.up('emergence-diff-viewer');
            
            panel.items.get(0).layout.setActiveItem(toggled ? 1 : 0);
            panel.items.get(1).layout.setActiveItem(toggled ? 1 : 0);
            
            // If switching back to viewers, re-render
            if (!toggled) {
            	panel.resetViewerCode();
            }
        }
    }]
    ,initDiffViewer: function()
    {
        if(this.path && this.sideAid && this.sideBid)
            this.loadFiles();  
    }
    ,loadFiles: function()
    {
        this.setLoading({msg: 'Opening Revisions: ' + this.sideAid + ',' + this.sideBid + ' /' + this.path});
        
        this.setSideTitle('A','Revision ' + this.sideAid);
        this.setSideTitle('B','Revision ' + this.sideBid);
        
        EmergenceEditor.store.DavClient.getRevision(this.path, this.sideAid, this.readyCodeARequestHandler, this)
        EmergenceEditor.store.DavClient.getRevision(this.path, this.sideBid, this.readyCodeBRequestHandler, this)
    }
    ,readyCodeARequestHandler: function(response) {
        this.codeA = response.responseText.replace(/\r\n?/g, '\n');;
        
        this.setCodeEditor('A',this.codeA);
        
        this.linesA = this.codeA.split('\n');
        
        if(this.codeB && this.linesB)
        {
            this.updateViewCode();
        }
    }
    ,readyCodeBRequestHandler: function(response) {
        this.codeB = response.responseText.replace(/\r\n?/g, '\n');
        
        this.setCodeEditor('B',this.codeB);
        
        this.linesB = this.codeB.split('\n');
        
        if(this.codeA && this.linesA)
        {
            this.updateViewCode();
        } 
    }
    ,updateViewCode: function() {        
        var diffdata = this.diff(this.linesA, this.linesB);

        // Give code to viewer for rendering            
        this.setCode('A', this.codeA, diffdata);
        this.setCode('B', this.codeB, diffdata);
        
        this.setLoading(false);   
    }
    ,setSideTitle: function(side,title)
    {
        this.items.get( side == 'A'?0:1 ).setTitle(title);
    }
    ,setCodeEditor: function(side,code) {
        this.items.get(side == 'A'?0:1).items.get(1).el.dom.value = code;
    }
    ,getCodeEditor: function(side) {
        return this.items.get(side == 'A'?0:1).items.get(1).el.dom.value;
    }
    ,resetViewerCode: function() {
        // Grab code and normalize line breaks
        var codeA = this.getCodeEditor('A').replace(/\r\n?/g, '\n'),
            codeB = this.getCodeEditor('B').replace(/\r\n?/g, '\n'),
            // Split code into lines
            linesA = codeA.split('\n'),
            linesB = codeB.split('\n'),
            // Perform diff
            diff = this.diff(linesA, linesB);

        // Give code to viewer for rendering            
        this.setCode('A', codeA, diff);
        this.setCode('B', codeB, diff);
    }
    ,initComponent: function() {
        
        this.itemId = 'diff:[' + this.sideAid + ',' + this.sideBid + ']/'+this.path;
        
    	this.codeViewer = new Ext.Template(
    		"<div class='ux-codeViewer'></div>"
    	);
    	
		this.lineTpl = new Ext.Template(
		    "<div class='ux-codeViewer-line'>",
		        "<span class='ux-codeViewer-lineNumber'>",
		            "{0:htmlEncode}",
		        "</span>",
		        "<span class='ux-codeViewer-lineText'>",
		            "{1}",
		        "</span>",
		    "</div>");
		this.emptyLineTpl = new Ext.Template(
		    "<div class='ux-codeViewer-line ux-codeViewer-empty'>",
		        "<span class='ux-codeViewer-lineNumber'>",
		        "</span>",
		    "</div>");
		this.tokenTpl = new Ext.Template(
		    "<span class='ux-codeViewer-token-{0}'>{1:htmlEncode}</span>"
		);    
    
    	this.lineTpl.compile();
    	this.emptyLineTpl.compile();
    	this.tokenTpl.compile();
    
    	this.items = [
    		{
	            cls: 'sideA',
	            title: 'Side A',
	            layout: 'card',
	            flex: 1,
	            margins: "6 3 6 6",
	            activeItem: 0,
	            items: [{
	                cls: 'codeViewerA'
	                ,xtype: 'box'
	                ,autoEl: {
				        tag: 'div'
				        ,cls: 'ux-codeViewer'
				    }
	                ,style: "overflow: scroll"
	                ,sideA: false
	            },{
	                cls: 'codeEditorA'
	                ,xtype: 'box'
	                ,autoEl: {
				        tag: 'textarea'
				        ,cls: 'ux-codeEditor'
				    }
	            }]
	        },{
	            cls: 'sideB',
	            title: 'Side B',
	            layout: 'card',
	            flex: 1,
	            margins: "6 6 6 3",
	            activeItem: 0,
	            items: [{
	                cls: 'codeViewerB'
	                ,xtype: 'box'
	                ,autoEl: {
				        tag: 'div'
				        ,cls: 'ux-codeViewer'
				    }
	                ,style: "overflow: scroll"
	                ,sideA: false
	            },{
	                cls: 'codeEditorB'
	                ,xtype: 'box'
	                ,autoEl: {
				        tag: 'textarea'
				        ,cls: 'ux-codeEditor'
				    }
	            }]            
	        }
	    ]; 
    
    
    
    	this.callParent();
    }
    ,diff: function(a,b)
    {
	    var calcMiddleSnake = function(a, aIndex, N, b, bIndex, M) {
	        var V = {},
	            rV = {},
	            maxD = Math.ceil((M+N)/2),
	            delta = N-M,
	            odd = (delta & 1) != 0,
	            x, y, xStart, yStart;
	        
	        V[1] = 0;
	        rV[delta-1] = N;
	        for (var D = 0; D <= maxD; D++) {
	            for (var k = -D; k<=D; k+=2) {
	                var down = (k == -D || k != D && V[k-1] < V[k+1]);
	                if (down) {
	                    xStart = x = V[k+1];
	                    yStart = xStart-(k+1);
	                }
	                else {
	                    xStart = x = V[k-1];
	                    yStart = xStart-(k-1);
	                    x++;
	                }
	                
	                y = x-k;
	                while (x < N && y < M && a[aIndex+x] == b[bIndex+y]) {
	                    x++;
	                    y++;
	                }
	                V[k] = x;
	                if (odd && k >= (delta-(D-1)) && k <= (delta+(D-1))) {
	                    if (rV[k] <= V[k]) {
	                        if (down && xStart == 0 && yStart == -1) {
	                            yStart++;
	                        }
	                        return {
	                            numDiffs: 2*D-1, 
	                            x: aIndex+xStart, 
	                            y: bIndex+yStart, 
	                            u: aIndex+x, 
	                            v: bIndex+y, 
	                            insertion: down,
	                            index: (down?bIndex+yStart:aIndex+xStart),
	                            forward: true
	                        };
	                    }
	                }
	            }
	            var dDelta = D+delta,
	                dDeltaNeg = -D+delta;
	                
	            for (var k = dDeltaNeg; k<=dDelta; k+=2) {
	                var up = (k == dDelta || k != dDeltaNeg && rV[k-1] < rV[k+1]);
	                if (up) {
	                    xStart = x = rV[k-1];
	                    yStart = xStart-(k-1);
	                }
	                else {
	                    xStart = x = rV[k+1];
	                    yStart = xStart-(k+1);
	                    x--;;
	                }
	                
	                y = x-k;
	                while (x > 0 && y > 0 && a[aIndex+x-1] == b[bIndex+y-1]) {
	                    x--;
	                    y--;
	                }
	                rV[k] = x;
	
	                if (!odd && k >= -D && k <= D) {
	                    if (rV[k] <= V[k]) {
	                        if (up && xStart == N && yStart == M+1) {
	                            yStart--;
	                        }
	                        return {
	                            numDiffs: 2*D, 
	                            x: aIndex+x, 
	                            y: bIndex+y, 
	                            u: aIndex+xStart, 
	                            v: bIndex+yStart, 
	                            insertion: up, 
	                            index: (up?bIndex+yStart-1:aIndex+xStart-1),
	                            forward: false
	                        };
	                    }
	                }
	            }
	        }
	        throw "Didn't find middle snake";
	    };
	    
	    var calcSES = function(a, aIndex, N, b, bIndex, M, ses) {
	        if (N == 0 && M == 0) { return; }
	
	        var middleSnake = calcMiddleSnake(a, aIndex, N, b, bIndex, M);
	        
	        if (middleSnake.numDiffs == 1) {
	            (middleSnake.insertion?ses.insertions:ses.deletions).push(middleSnake.index);
	        }
	        else if (middleSnake.numDiffs > 1) {
	            (middleSnake.insertion?ses.insertions:ses.deletions).push(middleSnake.index);
	            calcSES(a, aIndex, middleSnake.x - aIndex, b, bIndex, middleSnake.y - bIndex, ses);
	            calcSES(a, middleSnake.u, aIndex+N-middleSnake.u, b, middleSnake.v, bIndex+M-middleSnake.v, ses);
	        }
	    };
	    
		var ses = {
            insertions: [],
            deletions: []
        };
        calcSES(a, 0, a.length, b, 0, b.length, ses);
        ses.insertions.sort(function(a,b) {return a-b;});
        ses.deletions.sort(function(a,b) {return a-b;});
        return ses;
    }
    ,setCode: function(side,code, diff)
    {
        var el = this.items.get(side == 'A'?0:1).items.get(0).el;
    
        // Clear
        el.update("");
        
        // Create copies of the edit script
        var insertions = diff.insertions.slice(0),
            deletions = diff.deletions.slice(0),
            
            // Obtain reference to HTML templates
            lineTpl = this.lineTpl,
            emptyLineTpl = this.emptyLineTpl,
            
            // Create a "pre" tag to hold the code
            pre = el.createChild({tag: 'pre'}),
            
            // Normalize line-breaks in the code
            code = code.replace(/\r\n?/g, '\n'),
            
            // Split code into discrete lines
            lines = code.split('\n'),
        
            // Cursors/flags for walking the edit script
            sideAIndex = 0,
            sideBIndex = 0,
            sideAChangeIndex = deletions.shift(),
            sideBChangeIndex = insertions.shift(),
            prevWasModified = false;
        
        // Loop over each line
        for (var i = 0, n = lines.length; i<n; i++) {
            // Create the HTML for the line, including highlighting
            var el = lineTpl.append(pre, [i+1, this.highlightLine(lines[i])]);
            
            // By default we want to move both cursors forward
            var advanceA = true,
                advanceB = true;
            
            // If both cursors indicate a change, consider it to be a modification
            if (sideAIndex === sideAChangeIndex && sideBIndex === sideBChangeIndex) {
                Ext.fly(el).addCls('ux-codeViewer-modified');
                
                // Get next changes
                sideAChangeIndex = deletions.shift();
                sideBChangeIndex = insertions.shift();
                
                // Set modified flag so that following lines
                // are marked accordingly
                prevWasModified = true;
            }
            else {
                // Different logic for side A vs side B
                // For instance, an insert means an empty line on side A
                // and highlighting on side B
                if (side == 'A') {
                    // If there was a deletion
                    if (sideAIndex === sideAChangeIndex) {
                        // Either highlight as deleted or modified depending
                        // on the previous line
                        Ext.fly(el).addCls(prevWasModified ? 'ux-codeViewer-modified' : 'ux-codeViewer-deleted');
                        
                        // Get next change
                        sideAChangeIndex = deletions.shift();
                        
                        // Don't advance B cursor
                        advanceB = false;
                    }
                    else {
                        // If there were insertions, generate empty lines
                        while (sideBIndex === sideBChangeIndex) {
                            // Insert empty line
                            emptyLineTpl.insertBefore(el);
                            
                            // Get next change
                            sideBChangeIndex = insertions.shift();
                            
                            // Keep advancing as long as there was an insertion
                            sideBIndex++;
                        }
                    }
                }
                // Side B
                else {
                    //  If there was an insertation
                    if (sideBIndex == sideBChangeIndex) {
                        // Either highlight as inserted or modified depending
                        // on the previous line
                        Ext.fly(el).addCls(prevWasModified ? 'ux-codeViewer-modified' : 'ux-codeViewer-inserted');
                        
                        // Get next change
                        sideBChangeIndex = insertions.shift();
                        
                        // Don't advance A cursor
                        advanceA = false;
                    }
                    else {
                        // If there were deletions, generate empty lines
                        while (sideAIndex === sideAChangeIndex) {
                            // Insert empty line
                            emptyLineTpl.insertBefore(el);
                            
                            // Get next change
                            sideAChangeIndex = deletions.shift();
                            
                            // Keep advancing as long as there was a deletion
                            sideAIndex++;
                        }
                    }
                }
                
                // Reset modified flag
                prevWasModified = false;
            }
            
            // Advance cursors
            if (advanceA) { sideAIndex++; }
            if (advanceB) { sideBIndex++; }
        }
    }
	,highlightLine: function(line) {
		var scope = this;
	
        var matches = [];
        
        var between = function(idx, length) {
            for (var i = 0; i < matches.length; i++){
                var m = matches[i],
                    s = m[0],
                    e = m[1];
                if (s <= idx && (idx + length) <= e){
                    return true;
                }
            }
            return false;
        };
        
        var highlight = function(str, regex, cls, fn){
            regex.compile(regex);
            var match;

            while (match = regex.exec(str)){
                var mdata = fn ? fn(match) : [match.index, match[0]],
                    midx = mdata[0],
                    mstr = mdata[1];
                if (!between(midx, mstr.length)){
                    var replacement = scope.tokenTpl.apply([cls, mstr]),
                        diff = (replacement.length - mstr.length);
                    str = str.slice(0, midx) + replacement + str.slice(midx + mstr.length);
                    regex.lastIndex = midx + replacement.length;
                    for (var i = 0; i < matches.length; i++){
                        var m = matches[i];
                        if (m[1] < midx) continue;
                        
                        m[0] += diff;
                        m[1] += diff;
                    }
                    matches.push([midx, regex.lastIndex]);
                }
            }
            return str;
        };

        // String literals
        line = highlight(line, /("|')[^\1]*?\1/ig, 'string');
        
        // Integers and Floats
        line = highlight(line, /\d+\.?\d*/ig, 'number');

        // Function names
        line = highlight(line, /(\w+)\s*\:\s*function/ig, 'function', function(match){
            return [match.index, match[1]];
        });
        line = highlight(line, /function (\w+)/ig, 'function', function(match){
            return [match.index + 9, match[1]];
        });

        // Keywords
        line = highlight(line, /\b(this|function|null|return|true|false|new|int|float|break|const|continue|delete|do|while|for|in|switch|case|throw|try|catch|typeof|instanceof|var|void|with|yield|if|else)\b/ig, 'keyword');

        // Operators
        line = highlight(line, /\.|\,|\:|\;|\=|\+|\-|\&|\%|\*|\/|\!|\?|\<|\>|\||\^|\~/ig, 'operator');
        
        return line;
    }
});