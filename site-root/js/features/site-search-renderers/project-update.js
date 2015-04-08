$.registerSiteSearchRenderer(
    ['Laddr\\ProjectUpdate'],
    'Project Updates',
    function(result) {
        var date,
            link = $('<a />')
            .text(result.recordTitle)
            .attr('href', result.recordURL);

        if (result.Created && (date = new Date(result.Created * 1000))) {
            link.append($('<div class="muted" />').text(date.toDateString()));
        }

        return link;
    }
);