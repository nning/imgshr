$ ->
  $('.best_in_place').best_in_place()
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
