import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    uri: String,
    reload: Boolean
  }

  toggle(e) {
    const checkbox = e.target
    const data = new FormData()
    data.append(checkbox.name, checkbox.checked)

    fetch(this.uriValue, {
      method: "PUT",
      headers: {
        "X-Requested-With": "XMLHttpRequest",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.content
      },
      body: data
    }).then((response) => {
      if (!response.ok) throw new Error(`HTTP ${response.status}`)
      if (this.reloadValue) window.location.reload()
    }).catch((err) => {
      console.error("Failed to update setting", err)
      checkbox.checked = !checkbox.checked
    })
  }
}
