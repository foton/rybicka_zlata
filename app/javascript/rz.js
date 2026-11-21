// Entry point of the new frontend (ES modules via importmap).
import { Turbo } from "@hotwired/turbo-rails"
import "elements"

// Turbo is opt-in: only forms with data-turbo="true" (list row actions answered by
// Turbo Streams). Pages are loaded normally; Drive can be switched on later.
Turbo.config.drive.enabled = false
Turbo.config.forms.mode = "optin"
