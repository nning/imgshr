import { Turbo } from "@hotwired/turbo-rails"
import "./controllers"

Turbo.session.drive = false

function triggerContentUpdate() {
  document.dispatchEvent(new CustomEvent("content:update"))
  // jQuery 2.x keeps its own event registry and does not observe native
  // CustomEvents, so the dispatch above does not reach handlers registered
  // via $(document).on("content:update"). The legacy CoffeeScript (dropdowns,
  // tooltips, best_in_place, slider, raty) uses that jQuery form, so trigger
  // it explicitly. jQuery is loaded via legacy.js (deferred).
  if (typeof window.$ === "function") {
    window.$(document).trigger("content:update")
  }
}

document.addEventListener("turbo:frame-load", triggerContentUpdate)
document.addEventListener("turbo:render", triggerContentUpdate)

document.addEventListener("DOMContentLoaded", triggerContentUpdate)
