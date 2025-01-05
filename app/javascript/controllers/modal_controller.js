import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["popup", "button"]

  connect() {
    document.addEventListener("click", this.handleClickOutside.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside.bind(this))
  }

  toggle(e) {
    const modals = document.querySelectorAll(".modal__content")
    e.stopPropagation()
    
    modals.forEach(modal => {
      if (modal !== this.popupTarget) {
        modal.classList.add("hidden")
      }
    })
    this.popupTarget.classList.toggle("hidden")
    if (this.hasButtonTarget) {
    this.buttonTarget.classList.toggle("open")
    }
  }

  handleClickOutside(e) {
    if (!this.element.contains(e.target)) {
      this.popupTarget.classList.add("hidden")
      if (this.hasButtonTarget) {
      this.buttonTarget.classList.remove("open")
      }
    }
  }
}