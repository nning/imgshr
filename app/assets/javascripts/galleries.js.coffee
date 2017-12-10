$(document).on 'content:update', ->
  slider = $('.slider').first()
  if !slider.prev().hasClass('slider')
    slider.slider()

  $('#toggle-fifty-percent').off('click')
  $('#toggle-fifty-percent').click (e) ->
    $('#picture_grid').toggleClass('fifty-percent')

    icon = $(this).find('.glyphicon')
    icon.toggleClass('glyphicon-zoom-out')
    icon.toggleClass('glyphicon-zoom-in')

    false
