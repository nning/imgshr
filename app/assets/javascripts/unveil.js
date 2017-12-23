function unveil() {
  $('img').unveil()
}

$(document).on('content:update', () => {
  unveil()

  $('body').on('shown.bs.modal', () => {
    unveil()
  })
})
