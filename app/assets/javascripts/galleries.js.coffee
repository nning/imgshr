$(document).on 'content:update', ->
  slider = $('.slider').first()
  if !slider.prev().hasClass('slider')
    slider.slider()
