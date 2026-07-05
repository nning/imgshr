import { Turbo } from "@hotwired/turbo-rails"
import "./controllers"

Turbo.session.drive = false

function triggerContentUpdate() {
  // A native CustomEvent also triggers jQuery handlers registered via
  // $(document).on("content:update"), so a single dispatch is sufficient.
  document.dispatchEvent(new CustomEvent("content:update"))
}

document.addEventListener("turbo:frame-load", triggerContentUpdate)
document.addEventListener("turbo:render", triggerContentUpdate)

document.addEventListener("DOMContentLoaded", triggerContentUpdate)
