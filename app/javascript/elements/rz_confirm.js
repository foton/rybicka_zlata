// M3 confirmation dialog for <dialog id="confirm-dialog"> (ConfirmDialogComponent).
//   rzConfirm("Opravdu?", { yes: "Ano", no: "Ne" }) -> Promise<boolean>
// Used by Turbo forms (data-turbo-confirm) and plain forms (data-rz-confirm).
import { Turbo } from "@hotwired/turbo-rails"

export function rzConfirm(message, { yes, no } = {}) {
  const dialog = document.getElementById("confirm-dialog")
  if (!dialog) return Promise.resolve(window.confirm(message))

  dialog.querySelector(".rz-dialog__text").textContent = message
  setLabel(dialog.querySelector('[data-role="yes"]'), yes)
  setLabel(dialog.querySelector('[data-role="no"]'), no)
  dialog.returnValue = ""
  dialog.showModal()

  return new Promise((resolve) => {
    dialog.addEventListener("close", () => resolve(dialog.returnValue === "confirm"), { once: true })
  })
}

function setLabel(button, label) {
  button.textContent = label || button.dataset.defaultLabel
}

function labelsOf(element) {
  return { yes: element?.dataset.confirmYes, no: element?.dataset.confirmNo }
}

window.rzConfirm = rzConfirm

Turbo.config.forms.confirm = (message, form) => rzConfirm(message, labelsOf(form))

// Plain (non-Turbo) forms with data-rz-confirm: ask first, then submit again.
document.addEventListener("submit", (event) => {
  const form = event.target
  if (!(form instanceof HTMLFormElement) || !form.dataset.rzConfirm) return
  if (form.dataset.rzConfirmed) {
    delete form.dataset.rzConfirmed
    return
  }

  event.preventDefault()
  event.stopImmediatePropagation()
  const submitter = event.submitter
  rzConfirm(form.dataset.rzConfirm, labelsOf(form)).then((confirmed) => {
    if (!confirmed) return
    form.dataset.rzConfirmed = "true"
    form.requestSubmit(submitter && submitter.form === form ? submitter : undefined)
  })
}, true)
