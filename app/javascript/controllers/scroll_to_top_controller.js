import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    this.buttonTarget.style.display = "none"
    this.scrollHandler = () => this.toggle()
    window.addEventListener("scroll", this.scrollHandler, { passive: true })
  }

  disconnect() {
    window.removeEventListener("scroll", this.scrollHandler)
  }

  toggle() {
    if (window.scrollY > 320) {
      this.buttonTarget.style.display = ""
    } else {
      this.buttonTarget.style.display = "none"
    }
  }

  scrollTop() {
    window.scrollTo({ top: 0, behavior: "smooth" })
  }
}
