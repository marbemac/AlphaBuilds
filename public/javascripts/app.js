$(document).ready(function() {

    $('.portfolio-item').each(function(i) {
        var position = $(this).position();
        console.log(position);
        console.log('min: ' + position.top + ' / max: ' + parseInt(position.top + $(this).height()));
        $(this).scrollspy({
            min: position.top - 300,
            max: position.top + $(this).height(),
            onEnter: function(element, position) {
                if(console) console.log('entering ' +  $(element).data('name'));
                $(".portfolio-item.on").removeClass('on');
                $(element).addClass('on')
            },
            onLeave: function(element, position) {
                if(console) console.log('leaving ' +  $(element).data('name'));
                $(element).removeClass('on')
            }
        });
    });

    $("#inquiry-form").submit(function(e) {
        e.preventDefault();

        var $self = $(this)

        if ($self.find('.submit').hasClass('disabled')) {
            return;
        }

        $.ajax({
            type: "POST",
            url: "/inquiry",
            data: $self.serializeArray(),
            dataType: 'json',
            beforeSend: function(jqXHR, settings) {
                console.log('before');
                $self.find('.submit').addClass('disabled').val('Processing..')
            },
            success: function(data, textStatus, jqXHR) {
                if (data.status == 'error') {
                    alert('Please fill in all fields marked with a *.')
                    return;
                }

                $self.fadeOut(200, function() {
                    $('#inquiry-success').fadeIn(200)
                })

                _gaq.push(['_trackPageview', '/inquiry-success']);
            },
            complete: function() {
                $self.find('.submit').removeClass('disabled').val('Submit Inquiry')
            }
        });
    })

});