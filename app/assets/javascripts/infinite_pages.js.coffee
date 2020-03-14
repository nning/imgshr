$(document).on 'content:update', ->
  nextPage = $('#pictures[data-endless] [rel="next"]').attr('href')

  $('#pictures[data-endless]').infinitePages
    loading: ->
      $(this).text('← Loading...')
      $(this).attr('disabled', 'disabled')
    success: ->
      history.pushState({}, null, nextPage)
      nextPage = $(this).attr('href')
