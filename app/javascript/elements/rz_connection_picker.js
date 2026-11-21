// <rz-connection-picker> (ConnectionPickerComponent): progressive enhancement of plain
// radios / checkboxes - group bulk selection, "partial" group state, counts, search, filter chips.
// Row states: roles mode donee|none|donor, toggle mode selected|unselected.
class RzConnectionPicker extends HTMLElement {
  connectedCallback() {
    this.addEventListener("change", this.#onChange)
    this.addEventListener("input", this.#onInput)
    this.addEventListener("click", this.#onClick)
    this.#refresh()
  }

  disconnectedCallback() {
    this.removeEventListener("change", this.#onChange)
    this.removeEventListener("input", this.#onInput)
    this.removeEventListener("click", this.#onClick)
  }

  get #roles() { return this.dataset.mode === "roles" }
  get #contactRows() { return [...this.querySelectorAll(".rz-picker__row[data-id]")] }
  get #groupRows() { return [...this.querySelectorAll(".rz-picker__row[data-group]")] }

  #onChange = (event) => {
    const row = event.target.closest(".rz-picker__row")
    if (!row) return
    if (row.hasAttribute("data-group")) this.#applyGroup(row, event.target)
    this.#refresh()
  }

  #onInput = (event) => {
    if (event.target.matches("[data-search]")) this.#filter()
  }

  #onClick = (event) => {
    const chip = event.target.closest(".rz-chip[data-filter]")
    if (!chip) return
    this.querySelectorAll(".rz-chip[data-filter]").forEach((c) => c.setAttribute("aria-pressed", c === chip))
    this.#filter()
  }

  // a choice on a group row sets every member row
  #applyGroup(groupRow, input) {
    const ids = groupRow.dataset.memberIds.split(",")
    for (const row of this.#contactRows) {
      if (!ids.includes(row.dataset.id)) continue
      if (this.#roles) {
        const radio = row.querySelector(`input[type="radio"][value="${input.value}"]`)
        if (radio) radio.checked = true
      } else {
        row.querySelector('input[type="checkbox"]').checked = input.checked
      }
    }
  }

  #stateOf(row) {
    if (this.#roles) return row.querySelector('input[type="radio"]:checked')?.value || "none"
    return row.querySelector('input[type="checkbox"]').checked ? "selected" : "unselected"
  }

  #refresh() {
    const states = new Map(this.#contactRows.map((row) => [row.dataset.id, this.#stateOf(row)]))
    states.forEach((state, id) => { this.querySelector(`.rz-picker__row[data-id="${id}"]`).dataset.state = state })

    for (const groupRow of this.#groupRows) {
      const memberStates = [...new Set(groupRow.dataset.memberIds.split(",").map((id) => states.get(id)))]
      const state = memberStates.length === 1 ? memberStates[0] : "partial"
      groupRow.dataset.state = state
      if (this.#roles) {
        groupRow.querySelectorAll('input[type="radio"]').forEach((radio) => { radio.checked = radio.value === state })
      } else {
        const box = groupRow.querySelector("[data-group-toggle]")
        box.checked = state === "selected"
        box.indeterminate = state === "partial"
      }
    }

    this.querySelectorAll("[data-count]").forEach((el) => {
      el.textContent = [...states.values()].filter((s) => s === el.dataset.count).length
    })
    this.#filter()
  }

  // search only in the contact / group name, not in the role buttons
  #labelOf(row) {
    return (row.querySelector(".rz-picker__label")?.textContent || "").toLocaleLowerCase()
  }

  #filter() {
    const query = (this.querySelector("[data-search]")?.value || "").trim().toLocaleLowerCase()
    const filter = this.querySelector('.rz-chip[aria-pressed="true"]')?.dataset.filter || "all"
    let visible = 0
    for (const row of this.#contactRows) {
      const matches = this.#labelOf(row).includes(query) &&
        (filter === "all" || row.dataset.state === filter)
      row.hidden = !matches
      if (matches) visible++
    }
    for (const row of this.#groupRows) row.hidden = !this.#labelOf(row).includes(query)
    const empty = this.querySelector("[data-empty]")
    if (empty) empty.hidden = visible > 0
  }
}

customElements.define("rz-connection-picker", RzConnectionPicker)
