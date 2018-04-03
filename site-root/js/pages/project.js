(function() {
    var $updateModelCt = $('#post-update'),
        $readmeEditorCt = $('<div class="markdown-editor update-body"></div>'),
        $hiddenInput = $('<input type="hidden" name="Body">'),
        $textarea, epicEditor;

    $updateModelCt.on('show', function() {

        if (!epicEditor) {
            $textarea = $updateModelCt.find('textarea[name=Body]');

            // replace textarea with container div and hidden input
            $textarea.replaceWith($readmeEditorCt);
            $readmeEditorCt.after($hiddenInput);

            // initialize epiceditor
            epicEditor = new EpicEditor({
                container: $readmeEditorCt.get(0),
                autogrow: true,
                basePath: '/css/lib/epiceditor',
                theme: {
                    preview: '/themes/preview/cfa.css'
                }
            });

            $hiddenInput.closest('form').submit(function(event) {
                $hiddenInput.val(epicEditor.exportFile());
            });
        }

        epicEditor.load(function() {
            epicEditor.importFile('README', $textarea.val());
        });
    });
})();