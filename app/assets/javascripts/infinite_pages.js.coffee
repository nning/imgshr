inf =
  selMain: '#pictures[data-endless]'
  selButton: '#endless-toggle'
  selButtonText: '#endless-toggle .text'
  slug: $('#gallery').data('slug')

  pause: ->
    $(this.selMain).infinitePages('pause')
    $(this.selButtonText).text('Not endless')

  resume: ->
    $(this.selMain).infinitePages('resume')
    $(this.selButtonText).text('Endless')

$(document).on 'content:update', ->
  inf.cookie = 'endless_' + inf.slug

  $(inf.selMain).infinitePages
    loading: ->
      $(this).text('← Loading...')
      $(this).attr('disabled', 'disabled')

  if $.cookie(inf.cookie) == 'false'
    inf.pause()

$(inf.selButton).click (e) ->
  e.preventDefault()

  if $(inf.selButtonText).text() == 'Endless'
    inf.pause()
    $.cookie(inf.cookie, false)
  else
    inf.resume()
    $.cookie(inf.cookie, true)
