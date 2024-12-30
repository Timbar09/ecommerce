import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-preview"
export default class extends Controller {
  static targets = ["input", "preview"];

  connect() {
    this.inputTarget.addEventListener("change", this.previewImages.bind(this));
  }

  previewImages() {
    this.previewTarget.innerHTML = ''; // Clear the current images
    const files = this.inputTarget.files;

    Array.from(files).forEach(file => {
      const reader = new FileReader();
      reader.onload = (e) => {
        const img = document.createElement('img');
        img.src = e.target.result;
        img.classList.add('radius-lg');
        this.previewTarget.appendChild(img);
      };
      reader.readAsDataURL(file);
    });
  }
}
