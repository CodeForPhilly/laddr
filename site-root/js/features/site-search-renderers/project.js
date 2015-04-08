$.registerSiteSearchRenderer(
    ['Laddr\\Project'],
    'Projects',
    function(result) {
        var link = $('<a />')
            .text(result.recordTitle)
            .attr('href', result.recordURL);

        if (result.Stage) {
            link.append($('<div class="muted" />').text(result.Stage));
        }

        return link;
    }
);