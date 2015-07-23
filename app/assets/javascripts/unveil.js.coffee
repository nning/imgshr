$(document).on 'content:update', ->
  $('img').unveil()
  $('body').on 'shown.bs.modal', ->
    $('img').unveil()
