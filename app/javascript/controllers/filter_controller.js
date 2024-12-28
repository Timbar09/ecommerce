import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "button"]

  connect() {
    this.loadFilters()
    this.checkboxTargets.forEach(checkbox => {
      checkbox.addEventListener('change', this.filterOrders.bind(this))
    })

    document.addEventListener("click", this.handleClickOutside.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside.bind(this))
  }

  toggleFilter(e) {
    const filterOptionsContainers = this.element.querySelectorAll('.filter__form--group')
    e.stopPropagation()

    filterOptionsContainers.forEach(container => {
      container.classList.toggle("hidden")
    })
  }

  handleClickOutside(e) {
    const filterOptionsContainers = this.element.querySelectorAll('.filter__form--group')
    filterOptionsContainers.forEach(container => {
      if (!container.contains(e.target)) {
        container.classList.add("hidden")
      }
    })
  }

  loadFilters() {
    const storedFilters = JSON.parse(localStorage.getItem('orderFilters')) || []
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = storedFilters.includes(checkbox.value)
    })
    this.filterOrders()
  }

  storeFilters() {
    const selectedFilters = this.checkboxTargets.filter(checkbox => checkbox.checked).map(checkbox => checkbox.value)
    localStorage.setItem('orderFilters', JSON.stringify(selectedFilters))
  }

  filterOrders() {
    this.storeFilters()
    const selectedFilters = this.checkboxTargets.filter(checkbox => checkbox.checked).map(checkbox => checkbox.value)
    const ordersList = document.getElementById('orders-table')
    const orders = ordersList.querySelectorAll('.table__row')

    orders.forEach(order => {
      const fulfilled = order.dataset.fulfilled === 'true'
      const showOrder = (selectedFilters.includes('fulfilled') && fulfilled) ||
                        (selectedFilters.includes('unfulfilled') && !fulfilled) ||
                        selectedFilters.length === 0
      order.style.display = showOrder ? '' : 'none'
    })

    if (selectedFilters.length > 0) {
      this.buttonTarget.classList.add('highlight')
    } else {
      this.buttonTarget.classList.remove('highlight')
    }
  }
}