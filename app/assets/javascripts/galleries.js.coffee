$(document).on 'content:update', ->
  box = $('#endless_page')
  box.change (e) ->
    $.ajax
      type: 'put',
      url: box.data('uri'),
      data:
        gallery:
          endless_page: e.target.checked

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

  $('.slider').slider()

  $('#new_picture input[type="file"]').change (e) ->
    $('#new_picture button[type="submit"]').removeClass('disabled')
