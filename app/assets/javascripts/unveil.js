function unveil() {
  $('img').unveil()
}

$(document).on('content:update', function() {
  unveil()

  $('body').on('shown.bs.modal', function() {
    unveil()
  })
})
