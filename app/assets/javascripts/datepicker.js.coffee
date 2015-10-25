$(document).on 'content:update', ->
  $('[data-provide="datepicker"]').datepicker
    format: 'yyyy-mm-dd'
