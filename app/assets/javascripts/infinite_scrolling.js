let currentObserver = null

$(document).on('content:update', () => {
  if (currentObserver) {
    currentObserver.disconnect()
    currentObserver = null
  }

  const pagination = document.querySelector('.pagination')
  if (!pagination) return

  const pictures = document.getElementById('pictures')
  if (pictures && pictures.dataset.endless === 'false') return

  const callback = (entries, observer) => {
    const entry = entries[0]
    if (!entry || !entry.isIntersecting) return

    const next = entry.target.querySelector('a[rel=next]')
    if (!next) {
      observer.unobserve(entry.target)
      return
    }

    observer.unobserve(entry.target)

    $.ajax({
      url: next.href,
      dataType: 'script'
    })
  }

  const options = {
    rootMargin: '20%',
    threshold: 0
  }

  currentObserver = new IntersectionObserver(callback, options)
  currentObserver.observe(pagination)
})
