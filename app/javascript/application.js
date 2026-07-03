import { Turbo } from "@hotwired/turbo-rails"
import "./controllers"

Turbo.session.drive = false

function triggerContentUpdate() {
  document.dispatchEvent(new CustomEvent("content:update"))
  if (typeof window.$ === "function") {
    window.$(document).trigger("content:update")
  }
}

document.addEventListener("turbo:frame-load", triggerContentUpdate)
document.addEventListener("turbo:render", triggerContentUpdate)

document.addEventListener("DOMContentLoaded", triggerContentUpdate)
import "@hotwired/turbo-rails"
