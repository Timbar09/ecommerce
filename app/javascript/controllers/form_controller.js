import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  static targets = ["stepOne", "stepTwo", "next", "prev"]

  connect() {
    this.stepOneTarget.addEventListener('focusin', () => this.setActive("stepOne"))
    this.stepTwoTarget.addEventListener('focusin', () => this.setActive("stepTwo"))
    this.nextTarget.addEventListener('click', () => this.setActive("stepTwo"))
    this.prevTarget.addEventListener('click', () => this.setActive("stepOne"))
  }

  setActive(target) {
    if (target === "stepOne") {
      this.stepOneTarget.classList.add("step__active")
      this.stepTwoTarget.classList.remove("step__active")
    } else {
      this.stepTwoTarget.classList.add("step__active")
      this.stepOneTarget.classList.remove("step__active")
    }
  }
}
