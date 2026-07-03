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
    const parsedUrl = new URL(url, window.location.origin)
    parsedUrl.pathname = parsedUrl.pathname + ".js"

    const script = document.createElement("script")
    script.src = parsedUrl.toString()
    script.onload = () => {
      script.remove()
      this.loading = false
    }
    script.onerror = () => {
      script.remove()
      this.loading = false
    }
    document.head.appendChild(script)
  }
}
