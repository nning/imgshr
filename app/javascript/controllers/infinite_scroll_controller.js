import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { endless: Boolean }

  connect() {
    if (!this.endlessValue) return
    this.loading = false

    this.observer = new IntersectionObserver(
      (entries) => {
        const entry = entries[0]
        if (!entry || !entry.isIntersecting) return
        if (this.loading) return

        const next = entry.target.querySelector("a[rel=next]")
        if (!next) return

        this.loading = true
        this.loadMore(next.href)
      },
      { rootMargin: "20%", threshold: 0 }
    )

    this.observer.observe(this.element)
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }

  loadMore(url) {
    fetch(url, { headers: { Accept: "text/javascript" } })
      .then((response) => response.text())
      .then((js) => {
        const fn = new Function(js)
        fn()
      })
      .finally(() => {
        this.loading = false
      })
  }
}
