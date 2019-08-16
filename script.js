$(function() {
    keyEl = function(event) {
        var code = event.keyCode
        if (event.code == "ShiftLeft")
            code = '16a'
        if (event.code == "ShiftRight")
            code = '16b'
        return $('.key[code=' + code + ']');
    }

    const n = $('#write span').length;
    var i = 0;
    var k = $('span[i="' + i + '"]');
    var x = k.html();

    var right = 0;
    var wrong = 0;
    var start;

    var caps = false;

    $(window).keydown(function(event) {
        if (!start) start = new Date();

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
            const el = keyEl(event);

            el.addClass('down');

            const key = el.attr('key');
            if (event.key == x || x == ' ' && key == 'space') {
                k.addClass('done');
                k.removeClass('missed');

                right++;

                i++;
                if (i >= n) {
                    alert('done!');
                } else {
                    k = $('span[i="' + i + '"]');
                    x = k.html();
                }
            } else if (key != 16 && key != 20) {
                k.addClass('missed');
                wrong++;
            }

            const accuracy = Math.round(right / (right + wrong) * 100) + '%';
            $('#accuracy').html(accuracy);

            const now = new Date();
            const elapsed = (now - start) / 60000;
            const wpm = Math.round((i / 5) / elapsed);
            $('#wpm').html(wpm);
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