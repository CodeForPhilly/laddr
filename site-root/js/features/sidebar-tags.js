$(function() {
    $('.tags-ct .btn-group').delegate('.btn', 'click', function() {
        var tagsSummaryEl = $(this).closest('.tags-ct')
            ,tagGroup = $(this).data('group');

        tagsSummaryEl.find('.tags.'+tagGroup).show();
        tagsSummaryEl.find('.tags.'+tagGroup).siblings('.tags').hide();

        $(this).siblings().removeClass('active');
        $(this).addClass('active');

        return false;
    });
});