$.registerSiteSearchRenderer(
    ['Laddr\\ProjectBuzz'],
    'Project Buzz',
    function(result) {
        var matches,
            link = $('<a />')
            .text(result.Headline)
            .attr('href', result.recordURL);

        if (result.URL && (matches = result.URL.match(/https?:\/\/(www\.)?([^\/]+)/i))) {
            link.append($('<div class="muted" />').text(matches[2]));
        }

        return link;
    }
);