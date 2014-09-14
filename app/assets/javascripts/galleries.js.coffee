$ ->
  $('.best_in_place').best_in_place()
  $('.modal[aria-hidden!=""]').modal('show')

  box = $('#read_only')
  box.change (e) ->
    $.ajax
      type: 'put',
      url: box.data('uri'),
      data:
        gallery:
          read_only: e.target.checked
