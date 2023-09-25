$(document).on('content:update', () => {
  const callback = (entries, observer) => {
    const entry = entries[0]
    if (!entry?.isIntersecting) return

    const next = entry.target?.querySelector('a[rel=next]')?.href
    if (!next) {
      observer.unobserve(entry.target)
      return
    }

    $.ajax({
      url: next,
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
