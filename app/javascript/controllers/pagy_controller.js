import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pagy"
export default class extends Controller {
  connect() {
    this.nextButton = document.querySelector('.pagy.nav a:last-child')
    this.previousButton = document.querySelector('.pagy.nav a:first-child')
    this.pageButtons = document.querySelectorAll('.pagy.nav a')

    this.nextButton.classList.add('pagy__nav--next-button')
    this.previousButton.classList.add('pagy__nav--previous-button')

    const lastItemIndex = this.pageButtons.length - 1
    this.pageButtons.forEach((button, i) => {
      if (i > 0 && i < lastItemIndex) {
        button.classList.add('pagy__nav--page-button')
      }
    })

    this.nextButton.innerHTML = "Next >"
    
    this.previousButton.innerHTML = "< Prev"
  }
}
