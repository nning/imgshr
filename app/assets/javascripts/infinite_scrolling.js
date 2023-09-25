$(document).on('content:update', () => {
  const callback = (entries, observer) => {
    const entry = entries[0]
    if (!entry || !entry.isIntersecting) return

    const next = entry.target.querySelector('a[rel=next]')
    if (!next) {
      observer.unobserve(entry.target)
      return
    }

    $.ajax({
      url: next.href,
      dataType: 'script',
      success: () => observer.unobserve(entry.target)
    })
  }

  const options = {
    rootMargin: '20%',
    threshold: 0
  }

  const observer = new IntersectionObserver(callback, options)
  observer.observe(document.querySelector('.pagination'))
})
