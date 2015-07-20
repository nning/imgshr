$(document).on 'content:update', ->
  $('.picture .pager').each ->
    id = $(this).attr('data-id')
    id = '#lightbox' + id

    $(this).find('.previous').click ->
      $(id).modal('hide')

    $(this).find('.next').click ->
      $(id).modal('hide')
