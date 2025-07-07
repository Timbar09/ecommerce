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
      const cartItemContainer = document.createElement('div')
      cartItemContainer.classList.add('cart__list--item')
      cartItemContainer.innerHTML = `Item: ${item.name} - ${item.price/100.0} - Size: ${item.size} - Quantity: ${item.quantity}`

      const deleteButton = document.createElement('button')
      deleteButton.innerHTML = 'Remove'
      deleteButton.classList.add('cart__list--item__delete', 'btn')

      deleteButton.value = JSON.stringify({ id: item.id, size: item.size })
      deleteButton.addEventListener('click', this.removeFromCart)

      
      total += item.price * item.quantity
      
      cartItemContainer.appendChild(deleteButton)
      this.element.prepend(cartItemContainer)
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
    const values = JSON.parse(event.target.value)
    const { id, size } = values
    const index = cart.findIndex(item => item.id === id && item.size === size)

    cart.splice(index, 1)
    localStorage.setItem('cart', JSON.stringify(cart))

    location.reload()
  }

  checkout() {
    if (!this.cartAuthenticated) {
      window.location.href = "/users/sign_in";
      return;
    }
    
    const cart = JSON.parse(localStorage.getItem('cart'))
    const payload = { authenticity_token: "", cart: cart }

    const csrfToken = document.querySelector('[name="csrf-token"]').content

    fetch('/checkout', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify(payload)
    }).then(response => {
      if (response.ok) {
        response.json().then(body => {
          location.href = body.url
        })
      } else {
        response.json().then(body => {
          let errorContainer = document.getElementById('cart-errors')
          const errorElement = document.createElement('div')
          errorElement.innerText = `There was an error processing your order. Please try again. Error: ${body.error}`

          errorContainer.appendChild(errorElement)
        })
      }
    })

  }
}
