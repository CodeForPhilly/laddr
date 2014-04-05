(function() {
    var tagTitles = window.tagTitles,
        $textarea = $('textarea[name=About]'),
        markdownStr = $textarea.text(),
        $aboutEditorCt = $('<div class="markdown-editor about"></div>'),
        $hiddenInput = $('<input type="hidden" name="About">'),
        tagsInput, aboutEditor;

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
    $textarea.replaceWith($aboutEditorCt);
    $aboutEditorCt.after($hiddenInput);

    // initialize epiceditor
    aboutEditor = new EpicEditor({
        container: $aboutEditorCt.get(0),
        autogrow: true,
        basePath: '/lib/epiceditor',
        theme: {
            preview: '/themes/preview/cfa.css'
        }
    });

    aboutEditor.load(function() {
        aboutEditor.importFile('About', markdownStr);
    });

    $hiddenInput.closest('form').submit(function(event) {
        var $tagInput = tagsInput.$input,
            unconfirmedTag = $tagInput.val();

        $hiddenInput.val(aboutEditor.exportFile());

        // add any unconfirmed tags in case user didn't hit enter after last one
        if (unconfirmedTag) {
            tagsInput.add(unconfirmedTag);
            $tagInput.val('');
        }
    });
})();