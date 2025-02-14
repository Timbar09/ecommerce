import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="products"
export default class extends Controller {
  static values = { size: String, product: Object }

  addToCart() {
    const cart = localStorage.getItem('cart')

    if (this.sizeValue.length === 0) {
      alert('Please select a size')
      return
    }

    if (cart) {
      const cartArray = JSON.parse(cart)
      const productIndex = cartArray.findIndex(
        product => product.id === `${this.productValue.id}-${this.sizeValue}` && product.size === this.sizeValue
      )

      if (productIndex !== -1) {
        cartArray[productIndex].quantity += 1
      } else {
        cartArray.push({
          id: `${this.productValue.id}-${this.sizeValue}`,
          name: this.productValue.name,
          price: this.productValue.price,
          size: this.sizeValue,
          quantity: 1
        })
      }
      localStorage.setItem('cart', JSON.stringify(cartArray))
    } else {
      const cartArray = []
      cartArray.push({
        id: `${this.productValue.id}-${this.sizeValue}`,
        name: this.productValue.name,
        price: this.productValue.price,
        size: this.sizeValue,
        quantity: 1
      })
      localStorage.setItem('cart', JSON.stringify(cartArray))
    }

    console.log("cart: ", JSON.parse(localStorage.getItem('cart')))
    alert(`Successfully added size, ${this.letterSizeToWordSize(this.sizeValue)}, of ${this.productValue.name} to cart`)
  }

  selectSize(e) {
    this.sizeValue = e.target.value
    const selectedSizeElement = this.element.querySelector('.product__show--selected-size__value')
    selectedSizeElement.innerText = `You selected size: ${this.letterSizeToWordSize(this.sizeValue)}`
  }

  letterSizeToWordSize(letterSize) {
    const letterSizes = { S: 'Small', M: 'Medium', L: 'Large', XL: 'Extra Large' }

    return letterSizes[letterSize] || letterSize
  }
}
