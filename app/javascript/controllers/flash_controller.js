import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.classList.add("fade-out")
    }, 3000) // 3 seconds

    setTimeout(() => {
      this.element.remove()
    }, 4000) // 4 seconds
  }
}
