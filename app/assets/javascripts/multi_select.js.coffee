$(document).on 'content:update', ->
  console.log('init')

  $('#toggle-select').off('click')
  $('#toggle-select').on 'click', ->
    console.log('click')

    link = $(@)
    images = $('#picture_grid a')

    images.off('click')

    if !link.hasClass('selecting')
      link.contents().last().replaceWith(' Stop selection')
      images.on 'click', (e) ->
        e.preventDefault()
        $(@).toggleClass('selected')
    else
      link.contents().last().replaceWith(' Select')
      images.removeClass('selected')

    link.toggleClass('selecting')

    false
