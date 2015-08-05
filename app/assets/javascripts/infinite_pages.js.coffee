sel = '#pictures[data-endless=""]'

$(document).on 'content:update', ->
  $(sel).infinitePages
    loading: ->
      $(this).text('Loading... →')
      $(this).attr('disabled', 'disabled')

$('#endless-toggle').click (e) ->
  e.preventDefault()

  target = $('.text')
  if target.text() == 'Endless'
    $(sel).infinitePages('pause')
    $('.text', this).text('Not endless')
  else
    $(sel).infinitePages('resume')
    $('.text').text('Endless')
