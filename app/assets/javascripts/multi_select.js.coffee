select = (image) ->
  image.toggleClass('selected')

  input = $('<input/>',
    name: 'pictures[]',
    value: image.data('fingerprint'),
    type: 'hidden')

  $('#multi-select-delete').append(input)

reset_selection = (images) ->
  images.removeClass('selected')
  $('#multi-select-delete').find('[name="pictures[]"]').remove()


$(document).on 'content:update', ->
  toggle = $('#toggle-select')

  toggle.off('click')
  toggle.on 'click', ->
    link = $(@)
    images = $('#picture_grid a')

    images.off('click')

    if link.hasClass('selecting')
      link.contents().last().replaceWith(' Select')
      reset_selection(images)

    else
      link.contents().last().replaceWith(' Stop selection')

      images.on 'click', (e) ->
        e.preventDefault()
        select($(@))

    link.toggleClass('selecting')

    $('#multi-select-controls').toggleClass('hidden')

    false
