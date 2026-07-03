import { Controller } from "@hotwired/stimulus"
import { getKeyBase64 } from "../lib/crypto"
import qrcode from "qrcode"

export default class extends Controller {
  static targets = ["keyInput", "url", "qrCode", "copied"]

  connect() {
    getKeyBase64().then((key) => {
      const url = `${window.location.href}#${key}`
      this.keyInputTarget.value = key
      this.urlTarget.href = url

      qrcode.toCanvas(this.qrCodeTarget, url, (err) => {
        if (err) console.error("QR code generation error", err)
      })
    })
  }

  selectAllAndCopy() {
    this.keyInputTarget.focus()
    this.keyInputTarget.select()

    const showCopied = () => {
      this.copiedTarget.style.opacity = "1"
      this.copiedTarget.style.marginLeft = "1em"
    }

    if (navigator.clipboard) {
      navigator.clipboard.writeText(this.keyInputTarget.value).then(showCopied).catch(() => {
        document.execCommand("copy")
        showCopied()
      })
    } else {
      document.execCommand("copy")
      showCopied()
    }
  }
}
