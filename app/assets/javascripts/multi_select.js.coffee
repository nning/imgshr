$(document).on 'content:update', ->
  $('#toggle-select').off('click')
  $('#toggle-select').on 'click', ->
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

    $('#multi-select-controls').toggleClass('hidden')

    false

  $('#multi-select-delete').off('click')
  $('#multi-select-delete').on 'click', ->
    slug = $('#gallery').data('boss-token')
    fingerprints = $('#picture_grid .selected').map (_, image) ->
      $(image).data('fingerprint')

    fingerprints = fingerprints.toArray()

    console.log fingerprints

    $.ajax
      url: '/-' + slug + '/pictures/multi-delete',
      type: 'DELETE',
      data:
        pictures: fingerprints
      success: ->
        console.log @

    false
