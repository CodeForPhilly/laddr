Ext.define('EmrSkeletonTheme.window.Toast', {
    override: 'Ext.window.Toast',

    align: 'bl',
    width: 400,
    
    slideInAnimation: 'cubic-bezier(0.175, 0.885, 0.320, 1.275)', // easeOutBack
    slideInDuration: 250,
    // slideBackAnimation: 'cubic-bezier(0.680, -0.550, 0.265, 1.550)', // easeInOutBack
    slideBackAnimation: 'cubic-bezier(0.075, 0.820, 0.165, 1.000)', // easeOutCirc
    slideBackDuration: 500,
	hideDuration: 1000
});