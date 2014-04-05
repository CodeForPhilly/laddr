$(function() {
    $('.sidebar.left').delegate('.tagsSummary .tagFilter', 'click', function() {
        var tagsSummaryEl = $(this).closest('.tagsSummary')
            ,tagGroup = $(this).data('group');

        tagsSummaryEl.find('.tags.'+tagGroup).show();
        tagsSummaryEl.find('.tags.'+tagGroup).siblings('.tags').hide();

        $(this).siblings().removeClass('active');
        $(this).addClass('active');

        return false;
    });
});