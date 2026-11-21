// <rz-snackbar id="snackbar">: M3 snackbars for flash messages.
// Server-rendered items with data-autohide="ms" disappear after that time
// (paused while hovered or focused); others stay until the close button is used.
// API: document.querySelector("#snackbar").show("Text", { kind: "notice" | "error" })
const AUTOHIDE_MS = 10000

class RzSnackbar extends HTMLElement {
  connectedCallback() {
    this.querySelectorAll(".rz-snackbar__item").forEach((item) => this.#arm(item))
    this.addEventListener("click", this.#onClick)
  }

  disconnectedCallback() {
    this.removeEventListener("click", this.#onClick)
  }

  show(message, { kind = "notice" } = {}) {
    const item = document.createElement("div")
    item.className = `rz-snackbar__item rz-snackbar__item--${kind}`
    item.setAttribute("role", kind === "error" ? "alert" : "status")
    if (kind !== "error") item.dataset.autohide = AUTOHIDE_MS

    const text = document.createElement("span")
    text.className = "rz-snackbar__text"
    text.textContent = message

    const close = document.createElement("button")
    close.type = "button"
    close.className = "rz-icon-button rz-snackbar__close"
    close.dataset.dismiss = ""
    close.setAttribute("aria-label", this.dataset.dismissLabel || "Close")
    close.innerHTML = '<span class="rz-icon material-symbols-outlined" aria-hidden="true" translate="no">close</span>'

    item.append(text, close)
    this.append(item)
    this.#arm(item)
    return item
  }

  dismiss(item) {
    if (!item || item.classList.contains("is-leaving")) return
    item.classList.add("is-leaving")
    const remove = () => item.remove()
    item.addEventListener("animationend", remove, { once: true })
    setTimeout(remove, 400) // fallback when animations are disabled
  }

  #onClick = (event) => {
    const button = event.target.closest("[data-dismiss]")
    if (button) this.dismiss(button.closest(".rz-snackbar__item"))
  }

  #arm(item) {
    const ms = Number(item.dataset.autohide)
    if (!ms) return

    let timer
    const start = () => { clearTimeout(timer); timer = setTimeout(() => this.dismiss(item), ms) }
    const stop = () => clearTimeout(timer)
    item.addEventListener("mouseenter", stop)
    item.addEventListener("mouseleave", start)
    item.addEventListener("focusin", stop)
    item.addEventListener("focusout", start)
    start()
  }
}

customElements.define("rz-snackbar", RzSnackbar)
