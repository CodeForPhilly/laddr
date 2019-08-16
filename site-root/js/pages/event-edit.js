(function() {
    var $textarea = $('textarea[name=Description]'),
        markdownStr = $textarea.text(),
        $markdownEditorCt = $('<div class="markdown-editor event-description"></div>'),
        $hiddenInput = $('<input type="hidden" name="Description">'),
        readmeEditor;

    // replace textarea with container div and hidden input
    $textarea.replaceWith($markdownEditorCt);
    $markdownEditorCt.after($hiddenInput);

    // initialize epiceditor
    markdownEditor = new EpicEditor({
        container: $markdownEditorCt.get(0),
        autogrow: true,
        basePath: '/css/lib/epiceditor',
        theme: {
            preview: '/themes/preview/cfa.css'
        }
    });

    markdownEditor.load(function() {
        markdownEditor.importFile('Description', markdownStr);
    });

    $hiddenInput.closest('form').submit(function(event) {
        $hiddenInput.val(markdownEditor.exportFile());
    });
})();