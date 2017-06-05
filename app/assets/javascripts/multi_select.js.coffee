toggle_selection = (image) ->
  image.toggleClass('selected')

  form = $('#multi-select-delete')
  fingerprint = image.data('fingerprint')
  
  input = form.find('input[value="' + fingerprint + '"]')
  if input.length
    input.remove()
  else
    input = $('<input/>',
      name: 'pictures[]',
      value: fingerprint,
      type: 'hidden')

    form.append(input)

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
      link.contents().last().replaceWith(' Stop Select')

      images.on 'click', (e) ->
        e.preventDefault()
        toggle_selection($(@))

    link.toggleClass('selecting')

    $('#selection_menu').toggleClass('hidden')

    false
