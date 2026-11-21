// .form-add (contacts, groups, e-mail contacts): the "add" form stays collapsed behind its
// .new button until the button is clicked. Without JS (or with validation errors, when the
// server renders no .new button) the form is simply shown.
function setup(root = document) {
  root.querySelectorAll(".form-add").forEach((box) => {
    const button = box.querySelector(".new")
    const form = box.querySelector("form")
    if (!button || !form || box.dataset.formAdd) return

    box.dataset.formAdd = "collapsed"
    button.type = "button"
    button.setAttribute("aria-expanded", "false")
    button.addEventListener("click", () => {
      box.dataset.formAdd = "expanded"
      button.setAttribute("aria-expanded", "true")
      form.querySelector("input:not([type=hidden]), textarea, select")?.focus()
    })
  })
}

setup()
document.addEventListener("turbo:load", () => setup())
