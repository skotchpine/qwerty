$(function() {
    keyEl = function(event) {
        var code = event.keyCode
        if (event.code == "ShiftLeft")
            code = '16a'
        if (event.code == "ShiftRight")
            code = '16b'
        return $('.key[code=' + code + ']');
    }

    const write = $('#write');

    var caps = false;

    $(window).keydown(function(event) {
        if (event.keyCode == 16 && !caps) {
            $('.on').hide();
            $('.off').show();
        } else if (event.keyCode == 20) {
            caps = !caps;
            if (caps) {
                $('.on').hide();
                $('.off').show();
                $('.key[key="caps"]').addClass('down');
            } else {
                $('.off').hide();
                $('.on').show();
                $('.key[key="caps"]').removeClass('down');
            }
        } else {
            keyEl(event).addClass('down');
        }
    });
    $(window).keyup(function(event) {
        if (event.keyCode == 16 && !caps) {
            $('.off').hide();
            $('.on').show();
        } else if (event.keyCode != 20) {
            keyEl(event).removeClass('down');
        }
    });
});