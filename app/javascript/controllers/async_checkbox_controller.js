import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    uri: String,
    reload: Boolean
  }

  toggle(e) {
    const checked = e.target.checked
    const name = e.target.name
    const data = new FormData()
    data.append(name, checked)

    fetch(this.uriValue, {
      method: "POST",
      headers: {
        "X-Requested-With": "XMLHttpRequest",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.content,
        "X-HTTP-Method-Override": "PUT"
      },
      body: data
    }).then(() => {
      if (this.reloadValue) window.location.reload()
    })
  }
}
