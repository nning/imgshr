import { Controller } from "@hotwired/stimulus"
import { decrypt } from "../lib/crypto"

export default class extends Controller {
  static targets = ["image", "placeholder"]
  static values = { src: String }

  connect() {
    // Defer fetching/decrypting until the image is near the viewport,
    // matching the previous LazyLoad behavior.
    this.observer = new IntersectionObserver(
      (entries) => {
        if (!entries.some((entry) => entry.isIntersecting)) return
        this.observer.disconnect()
        this.observer = null
        this.load()
      },
      { rootMargin: "50%" }
    )
    this.observer.observe(this.element)
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }

  load() {
    fetch(this.srcValue)
      .then((response) => {
        if (!response.ok) throw new Error(`HTTP ${response.status}`)
        return response.arrayBuffer()
      })
      .then((body) => decrypt(body))
      .then((decrypted) => {
        this.imageTarget.src = `data:image/jpeg;base64,${btoa(decrypted)}`
        this.imageTarget.style.display = ""
        this.placeholderTarget.style.display = "none"
      })
      .catch((err) => {
        console.error(err)
        this.placeholderTarget.innerHTML =
          '<span class="glyphicon glyphicon-remove-circle"></span>'
      })
  }
}
