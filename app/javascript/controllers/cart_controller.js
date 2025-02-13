import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cart"
export default class extends Controller {
  initialize() {
    const cart = JSON.parse(localStorage.getItem('cart'))

    if (!cart) {
      return
    }

    let total = 0

    cart.forEach(item => {
      const div = document.createElement('div')
      div.classList.add('cart__list--item')
      div.innerHTML = `Item: ${item.name} - ${item.price/100.0} - Size: ${item.size} - Quantity: ${item.quantity}`

      const deleteButton = document.createElement('button')
      deleteButton.innerHTML = 'Remove'
      deleteButton.classList.add('cart__list--item__delete', 'btn')

      deleteButton.value = item.id
      deleteButton.addEventListener('click', this.removeFromCart)

      
      total += item.price * item.quantity
      
      div.appendChild(deleteButton)
      this.element.prepend(div)
    })

    let totalElementContainer = document.getElementById("cart-total")
    const totalElement = document.createElement('div')
    totalElement.innerText = `Total: ${total/100.0}`
    totalElementContainer.appendChild(totalElement)
  }

  clearCart() {
    localStorage.removeItem('cart')
    location.reload()
  }

  removeFromCart(event) {
    const cart = JSON.parse(localStorage.getItem('cart'))
    const id = event.target.value

    const index = cart.findIndex(item => item.id === id)
    cart.splice(index, 1)
    localStorage.setItem('cart', JSON.stringify(cart))

    location.reload()
  }

  checkout() {
    alert('Checkout')
  }
}
