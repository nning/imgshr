import { Controller } from "@hotwired/stimulus"
import qrcode from "qrcode"

export default class extends Controller {
  static values = { content: String }

  connect() {
    if (this.contentValue) {
      this.render()
    }
  }

  contentValueChanged() {
    if (this.contentValue) {
      this.render()
    }
  }

  render() {
    qrcode.toCanvas(this.element, this.contentValue, (err) => {
      if (err) console.error(this.contentValue, err)
    })
  }
}
