$(document).on 'content:update', ->
  $('#pictures').infinitePages
    loading: ->
      $(this).text('Loading... →')
      $(this).attr('disabled', 'disabled')
