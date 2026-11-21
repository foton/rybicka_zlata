// Theme switch (Layout::ThemeMenuComponent): light / dark / system, applied instantly.
// Stores the same "theme" cookie as StaticController#change_theme, so the next page
// is rendered by the server with the chosen data-theme (no flash of the wrong theme).
const THEMES = ["light", "dark"]
const MAX_AGE = 60 * 60 * 24 * 365 * 20

function setCookie(value) {
  const secure = location.protocol === "https:" ? "; Secure" : ""
  const age = value ? MAX_AGE : 0
  document.cookie = `theme=${value || ""}; path=/; max-age=${age}; SameSite=Lax${secure}`
}

function applyTheme(choice) {
  const root = document.documentElement
  if (THEMES.includes(choice)) {
    root.dataset.theme = choice
    setCookie(choice)
  } else {
    delete root.dataset.theme
    setCookie(null)
  }

  document.querySelectorAll("[data-theme-choice]").forEach((item) => {
    if (item.dataset.themeChoice === choice) item.setAttribute("aria-current", "true")
    else item.removeAttribute("aria-current")
  })

  const toggle = document.querySelector("[data-theme-icons]")
  const icon = toggle?.querySelector(".rz-icon")
  if (icon) icon.textContent = JSON.parse(toggle.dataset.themeIcons)[choice]
}

document.addEventListener("click", (event) => {
  const link = event.target.closest("[data-theme-choice]")
  if (!link) return

  event.preventDefault()
  applyTheme(link.dataset.themeChoice)
  link.closest("[popover]")?.hidePopover()
})
