(function() {
    var tagTitles = window.tagTitles,
        $textarea = $('textarea[name=README]'),
        markdownStr = $textarea.text(),
        $readmeEditorCt = $('<div class="markdown-editor readme"></div>'),
        $hiddenInput = $('<input type="hidden" name="README">'),
        tagsInput, readmeEditor;

    if (tagTitles) {
        tagsInput = $('#tagsInput').tagsinput({
            typeahead: {
                source: tagTitles
            },
            confirmKeys: [13, 44, 188],
            tagClass: function(item) {
                var cls = ['label'];

                if (item.match(/^tech\./)) {
                    cls.push('tag-tech');
                } else if (item.match(/^topic\./)) {
                    cls.push('tag-topic');
                } else if (item.match(/^event\./)) {
                    cls.push('tag-event');
                }

                return cls.join(' ');
            }
        })[0];

        tagsInput.$input.attr('placeholder', tagsInput.$element.attr('placeholder')).attr('size', 20);
    }

    // replace textarea with container div and hidden input
    $textarea.replaceWith($readmeEditorCt);
    $readmeEditorCt.after($hiddenInput);

    // initialize epiceditor
    readmeEditor = new EpicEditor({
        container: $readmeEditorCt.get(0),
        autogrow: true,
        basePath: '/lib/epiceditor',
        theme: {
            preview: '/themes/preview/cfa.css'
        }
    });

    readmeEditor.load(function() {
        readmeEditor.importFile('README', markdownStr);
    });

    $hiddenInput.closest('form').submit(function(event) {
        var $tagInput = tagsInput.$input,
            unconfirmedTag = $tagInput.val();

        $hiddenInput.val(readmeEditor.exportFile());

        // add any unconfirmed tags in case user didn't hit enter after last one
        if (unconfirmedTag) {
            tagsInput.add(unconfirmedTag);
            $tagInput.val('');
        }
    });
})();