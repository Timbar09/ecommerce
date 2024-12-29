import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nav-expand"
export default class extends Controller {
  static targets = [ "nav", "minimized", "expanded" ]

  connect() {
    this.expanded = false
  }

  toggle() {
    this.expanded = !this.expanded
    this.navTarget.classList.toggle("expanded")
    
    if (this.expanded) {
      this.minimizedTarget.classList.add("hidden")
      this.expandedTarget.classList.remove("hidden")
    } else {
      this.minimizedTarget.classList.remove("hidden")
      this.expandedTarget.classList.add("hidden")
    }
  }
}
