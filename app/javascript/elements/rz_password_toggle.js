// Show / hide password: trailing icon button of RzFormBuilder#password_field
// ([data-password-toggle], rendered hidden so it only appears when JS works).
const ICON_SHOWN = "visibility_off"
const ICON_HIDDEN = "visibility"

function enableToggles(root = document) {
  root.querySelectorAll("[data-password-toggle][hidden]").forEach((button) => { button.hidden = false })
}

document.addEventListener("click", (event) => {
  const button = event.target.closest("[data-password-toggle]")
  if (!button) return

  const input = button.closest(".rz-text-field").querySelector("input")
  const show = input.type === "password"
  input.type = show ? "text" : "password"
  button.setAttribute("aria-pressed", show)
  const label = show ? button.dataset.hideLabel : button.dataset.showLabel
  button.setAttribute("aria-label", label)
  button.title = label
  button.querySelector(".rz-icon").textContent = show ? ICON_SHOWN : ICON_HIDDEN
  input.focus()
})

// a revealed password goes back to hidden before the form is sent (password managers, history)
document.addEventListener("submit", (event) => {
  event.target.querySelectorAll?.("[data-password-toggle][aria-pressed='true']").forEach((button) => button.click())
}, true)

enableToggles()
document.addEventListener("turbo:load", () => enableToggles())
