(function() {
    var cachedTagData = window.localStorage && localStorage.getItem('tags'),
        now = Date.now(),
        cacheTTL = 1000 * 60 * 60 * 24; // 1 day in milliseconds


    // try to load tag data from localStorage cache
    if (cachedTagData) {
        cachedTagData = JSON.parse(cachedTagData);

        if (cachedTagData.timestamp && cachedTagData.timestamp + cacheTTL > now) {
            _initializeTagFields(cachedTagData);
            return;
        }
    }


    // load tag data from server
    $.ajax({
        url: '/tags',
        headers: {
            Accept: 'application/json'
        },
        data: {
            summary: true
        }
    })
        .done(function(data) {
            data.timestamp = now;
    
            // store to localstorage
            if (window.localStorage) {
                localStorage.setItem('tags', JSON.stringify(data));
            }
    
            _initializeTagFields(data);
        });


    // called after tag data is available
    function _initializeTagFields(tagData) {
        $('input[type=tags]').each(function() {
            var $input = $(this),
                tagPrefix = $input.data('tag-prefix'),
                prefixTags = $.grep(tagData.data, function(tag) {
                    return tag.Handle.indexOf(tagPrefix + '.') === 0;
                }),
                tagsInput;

            // initialize taginput UI
            tagsInput = $input.tagsinput({
                confirmKeys: [13, 44, 188],
                tagClass: tagPrefix ? 'label label-info tag-' + tagPrefix : undefined,
                typeaheadjs: {
                    name: tagPrefix,
                    local: prefixTags,
                    displayKey: 'Title',
                    valueKey: 'Title',
                    source: function(query, callback) {
                        var substringRegex = new RegExp(query, 'i');

                        callback($.grep(prefixTags, function(tag) {
                            return substringRegex.test(tag.Title);
                        }));
                    }
                }
            })[0];
            
            
            $input.closest('form').submit(function(event) {
                var unconfirmedTag = tagsInput.$input.val();
        
                // add any unconfirmed tags in case user didn't hit enter after last one
                if (unconfirmedTag) {
                    tagsInput.add(unconfirmedTag);
                    tagsInput.$input.val('');
                }
            });
        });
    }
})();

//        tagsInput.$input.attr('placeholder', tagsInput.$element.attr('placeholder')).attr('size', 20);
//    }