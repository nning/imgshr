$(document).on 'content:update', ->
  $('.best_in_place').best_in_place()
  
$(document).on 'page:change', ->
  $(document).trigger('content:update')

  $('.modal[aria-hidden!=""]').modal('show')

  $('img').unveil()
  $('body').on 'shown.bs.modal', ->
    $('img').unveil()

  box = $('#read_only')
  box.change (e) ->
    $.ajax
      type: 'put',
      url: box.data('uri'),
      data:
        gallery:
          read_only: e.target.checked

  box = $('#ratings_enabled')
  box.change (e) ->
    $.ajax
      type: 'put',
      url: box.data('uri'),
      data:
        gallery:
          ratings_enabled: e.target.checked

  $('#pictures').infinitePages
    debug: true
    success: ->
      $(document).trigger('content:update')
