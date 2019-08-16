(function() {
    var $textarea = $('textarea[name=README]'),
        markdownStr = $textarea.text(),
        $readmeEditorCt = $('<div class="markdown-editor readme"></div>'),
        $hiddenInput = $('<input type="hidden" name="README">'),
        readmeEditor;

    // replace textarea with container div and hidden input
    $textarea.replaceWith($readmeEditorCt);
    $readmeEditorCt.after($hiddenInput);

    // initialize epiceditor
    readmeEditor = new EpicEditor({
        container: $readmeEditorCt.get(0),
        autogrow: true,
        basePath: '/css/lib/epiceditor',
        theme: {
            preview: '/themes/preview/cfa.css'
        }
    });

    readmeEditor.load(function() {
        readmeEditor.importFile('README', markdownStr);
    });

    $hiddenInput.closest('form').submit(function(event) {
        $hiddenInput.val(readmeEditor.exportFile());
    });
})();
