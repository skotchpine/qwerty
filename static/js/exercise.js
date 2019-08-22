$(function() {
    const keyEl = function(event) {
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

    const cursor = '<span class="cursor">|</span>';
    $('span[i="' + i + '"]').before(cursor);

    var missed = 0;
    var start;
    var accuracy;
    var wpm;

    const updateView = function() {
        if (!start) return;

        accuracy = (Math.round(i / (i + missed) * 100)) + '%';

        const now = new Date();
        const elapsed = (now - start) / 60000;
        wpm = Math.round((i / 5) / elapsed);
        $('#wpm .figure').html(wpm);
    }

    const updateViewInterval = setInterval(updateView, 1000);

    var caps = false;

    $(window).keydown(function(event) {
        // https://stackoverflow.com/questions/18967532/window-location-reload-not-working-for-firefox-and-chrome
        if (event.keyCode == 27) {
            setTimeout(function() {
                window.location.reload();
            });
        }

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

                i++;
                $('.cursor').remove();
                $('span[i="' + i + '"]').before(cursor);


                if (i < n) {
                    k = $('span[i="' + i + '"]');
                    x = k.html();
                } else {
                    updateView();
                    clearInterval(updateViewInterval);
                    $.post(window.location.href, {
                        wpm: wpm,
                        right: i,
                        wrong: missed,
                        accuracy: accuracy,
                    }).done(function(data, status, xhr) {
                        window.location = '/app/submissions/' + JSON.parse(data)['id'];
                    }).fail(function(data, status, xhr) {
                        alert('something bad happened!');
                    });
                }
            } else if (key != 16 && key != 20) {
                k.addClass('missed');

                missed++;
            }

            $('#typos .figure').html(missed);
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