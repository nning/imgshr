$(document).on 'content:update', ->
  $('#pictures[data-endless]').infinitePages
    loading: ->
      $(this).text('← Loading...')
      $(this).attr('disabled', 'disabled')
