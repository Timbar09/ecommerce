import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nav-expand"
export default class extends Controller {
  static targets = [ "nav", "minimized", "expanded" ]

  connect() {
    this.expanded = localStorage.getItem("navExpanded") === "true"
    this.updateNavState()
  }

  toggle() {
    this.expanded = !this.expanded
    localStorage.setItem("navExpanded", this.expanded)
    this.updateNavState()
  }

  updateNavState() {
    this.navTarget.classList.toggle("expanded", this.expanded)
    
    if (this.expanded) {
      this.minimizedTarget.classList.add("hidden")
      this.expandedTarget.classList.remove("hidden")
    } else {
      this.minimizedTarget.classList.remove("hidden")
      this.expandedTarget.classList.add("hidden")
    }
  }
}
