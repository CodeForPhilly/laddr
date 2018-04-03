(function() {
    var $textarea = $('textarea[name=About]'),
        markdownStr = $textarea.text(),
        $aboutEditorCt = $('<div class="markdown-editor about"></div>'),
        $hiddenInput = $('<input type="hidden" name="About">'),
        aboutEditor;

    // replace textarea with container div and hidden input
    $textarea.replaceWith($aboutEditorCt);
    $aboutEditorCt.after($hiddenInput);

    // initialize epiceditor
    aboutEditor = new EpicEditor({
        container: $aboutEditorCt.get(0),
        autogrow: true,
        basePath: '/css/lib/epiceditor',
        theme: {
            preview: '/themes/preview/cfa.css'
        }
    });

    aboutEditor.load(function() {
        aboutEditor.importFile('About', markdownStr);
    });

    $hiddenInput.closest('form').submit(function(event) {
        $hiddenInput.val(aboutEditor.exportFile());
    });
})();