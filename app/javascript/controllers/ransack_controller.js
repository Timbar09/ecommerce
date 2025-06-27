import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ransack"
export default class extends Controller {
  static targets = ["search", "searchButton", "input", "checkbox"]

  connect() {
    // On every page reload, uncheck all checkboxes
    this.uncheckAll()
    this.searchButtonTarget.addEventListener("click", this.handleOpenSearch.bind(this))
    // When the input ransack data-value-type is number, handle the input accordingly
    if (this.inputTarget.dataset.ransackValueType === "number") {
      this.inputTarget.addEventListener("input", (event) => {
        const value = event.target.value.replace(/[^0-9.]/g, "")
        event.target.value = value
      })
    }
    this.inputTarget.addEventListener("blur", () => {
      setTimeout(() => {
        this.handleCloseSearch()
      }, 250)
    })
    this.inputTarget.addEventListener("input", () => {
      if (this.inputTarget.value.trim() === "") {
        this.handleCloseSearch()
      }
    })
  }

  handleOpenSearch() {
    const search = this.searchTarget
    const button = this.searchButtonTarget

    search.classList.add("ransack__search--open")
    button.classList.add("ransack__search--button__hide")
    this.inputTarget.focus()
  }

  handleCloseSearch() {
    const search = this.searchTarget
    const button = this.searchButtonTarget

    if (this.inputTarget.value.trim() === "") {
      search.classList.remove("ransack__search--open")
      button.classList.remove("ransack__search--button__hide")
    }
  }

  uncheckAll() {
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = false
    })
  }
}
