$(document).ready(function(){
    $('#url').zclip({
        path: '/flash/ZeroClipboard.swf',
        clickAfter: false,
        copy: function() { return $('#url').attr('value') },
        afterCopy:function(){
            $('#url').focus();
            $('#url').select();
        }
    });
});
