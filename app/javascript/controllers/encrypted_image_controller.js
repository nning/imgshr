import { Controller } from "@hotwired/stimulus"
import { decrypt } from "../lib/crypto"

export default class extends Controller {
  static targets = ["image", "placeholder"]
  static values = { src: String }

  connect() {
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
