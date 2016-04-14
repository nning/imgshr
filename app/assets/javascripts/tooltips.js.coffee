$(document).on 'content:update', ->
  console.log('tooltip?')
  $('[data-toggle="tooltip"]').tooltip()
