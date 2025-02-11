import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="carousel"
export default class extends Controller {
  static targets = ["slide", "indicator"];

  connect() {
    this.currentIndex = 0;
    this.showSlide(this.currentIndex);
  }

  next() {
    this.currentIndex = (this.currentIndex + 1) % this.slideTargets.length;
    this.showSlide(this.currentIndex);
  }

  prev() {
    this.currentIndex = (this.currentIndex - 1 + this.slideTargets.length) % this.slideTargets.length;
    this.showSlide(this.currentIndex);
  }

  showSlide(index) {
    this.slideTargets.forEach((slide, i) => {
      slide.classList.toggle("active", i === index);
    });
    this.indicatorTargets.forEach((indicator, i) => {
      indicator.classList.toggle("active", i === index);
    });
  }

  goToSlide(event) {
    this.currentIndex = parseInt(event.currentTarget.dataset.slideTo);
    this.showSlide(this.currentIndex);
  }
}