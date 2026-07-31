import { Controller } from "@hotwired/stimulus"

// Shows an in-flow "Loading..." placeholder over a natively-loading image
// until the image has finished loading. Without JavaScript the image is
// still rendered in-flow and loads normally; the placeholder only appears
// when this controller connects and adds the `lazy-image--loading` class,
// which reserves layout space (matching the old React LazyPicture and the
// encrypted-image branch).
export default class extends Controller {
  static targets = ["image", "placeholder"]

  connect() {
    if (!this.hasImageTarget || !this.hasPlaceholderTarget) return

    // Already loaded (cached / decoded): don't flash the placeholder.
    if (this.imageTarget.complete && this.imageTarget.naturalWidth > 0) {
      return
    }

    this.element.classList.add("lazy-image--loading")
  }

  onLoad() {
    this.element.classList.remove("lazy-image--loading")
  }

  onError() {
    this.element.classList.remove("lazy-image--loading")
    this.element.classList.add("lazy-image--error")
    const status = this.placeholderTarget.querySelector(".lazy-image__status")
    if (status) status.textContent = "Failed to load"
  }
}
