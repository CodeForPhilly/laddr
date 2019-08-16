(function() {
    $('select[name^="tags["]').filter(function() {
        return $(this).closest(':disabled').length == 0;
    }).each(function() {
        var $select = $(this),
            tagPrefix = $select.data('tag-prefix'),
            tagPlaceholder = $select.data('tag-placeholder'),
            baseConfig = {
                placeholder: tagPlaceholder,
                allowClear: tagPlaceholder && !$select.prop('required'),
                multiple: $select.prop('multiple'),
            },
            remoteConfig = {
                minimumInputLength: 1,
                ajax: {
                    url: '/tags',
                    dataType: 'json',
                    delay: 250,
                    data: function (params) {
                        var q = params.term;

                        if (tagPrefix) {
                            q += ' prefix:'+tagPrefix
                        }

                        return {
                            q: q,
                            format: 'json',
                            summary: true
                        };
                    },
                    processResults: function (data, params) {
                        return {
                            results: $.map(data.data, function (data) {
                                data.id = data.id || data.Handle || data.ID;
                                data.text = data.text || data.Title;
                                return data;
                            }),
                            pagination: {
                                more: params.total < params.offset + params.limit
                            }
                        };
                    }
                }
            };

        // initialize remote selection
        $select.select2($.extend(
            {},
            typeof $select.data('limited') == 'string' ? {} : remoteConfig,
            baseConfig
        ));
    });
})();