// Entry point of the new frontend (ES modules via importmap).
import { Turbo } from "@hotwired/turbo-rails"
import "elements"

// Legacy pages still run on jQuery + jquery_ujs + MDL, which would clash with
// Turbo Drive (no re-init after body swap, double handling of forms/links).
// Turbo stays opt-in (data-turbo="true") until those pages are migrated.
Turbo.config.drive.enabled = false
Turbo.config.forms.mode = "optin"

// Content inserted by Turbo Streams may still contain MDL widgets (tooltips, ...)
// of not yet migrated partials: let MDL upgrade them after each stream render.
document.addEventListener("turbo:before-stream-render", (event) => {
  const render = event.detail.render
  event.detail.render = async (streamElement) => {
    await render(streamElement)
    window.componentHandler?.upgradeDom()
  }
})
