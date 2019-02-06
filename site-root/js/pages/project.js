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
                basePath: '/lib/epiceditor',
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

$( "#open_role_table" ).on( "click", "a[title^='Apply']", function( event ) {
    $('#add-application').modal({show: 'true'});
    $("#add-application-title").text($( this ).attr( "data-role_name"));
    $("#inputRoleId").val($( this ).attr( "data-role_id"));
});

$( "#open_role_table" ).on( "click", "a[title^='Edit Role']", function( event ){
    $('#modify-role').modal({show: 'true'});
    $("#inputRoleId").val($( this ).attr( "data-role_id"));
    $("#inputRole").val($( this ).attr( "data-role_name"));
    $("#inputRoleDescription").val($( this ).attr( "data-role_description"));
    $("#inputUsername").val($( this ).attr( "data-role_person"));
});

$( "#role_table" ).on( "click", "a[title^='Edit Role']", function( event ) {
    $('#modify-role').modal({show: 'true'});
    $("#inputRoleId").val($( this ).attr( "data-role_id"));
    $("#inputRole").val($( this ).attr( "data-role_name"));
    $("#inputRoleDescription").val($( this ).attr( "data-role_description"));
    $("#inputUsername").val($( this ).attr( "data-role_person"));
});