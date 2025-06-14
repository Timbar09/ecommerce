import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ransack"
export default class extends Controller {
  static targets = ["form", "button", "input"]

  connect() {
    this.buttonTarget.addEventListener("click", this.handleOpenSearch.bind(this))
    this.inputTarget.addEventListener("blur", this.handleCloseSearch.bind(this))
  }

  handleOpenSearch() {
    const form = this.formTarget
    const button = this.buttonTarget

    form.classList.add("ransack__form--open")
    button.classList.add("ransack__form--icon__hide")
    this.inputTarget.focus()
  }

  handleCloseSearch() {
    const form = this.formTarget
    const button = this.buttonTarget

    if (this.inputTarget.value.trim() === "") {
      form.classList.remove("ransack__form--open")
      button.classList.remove("ransack__form--icon__hide")
    }
  }
}
