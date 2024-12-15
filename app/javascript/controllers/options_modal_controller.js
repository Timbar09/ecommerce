import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="options-modal"
export default class extends Controller {
  static targets = ["popup"]

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
  }

  handleClickOutside(e) {
    if (!this.element.contains(e.target)) {
      this.popupTarget.classList.add("hidden")
    }
  }
}