class HomeController < ApplicationController
  include RansackSearchable

  def index
    ransack_query(Product)
    @products = @q.result(distinct: true)

    @hero_product = Product.find_by(id: 8) || Product.first
    @hero_product_category = @hero_product.category

    @side_product = Product.find_by(id: 5) || Product.last

    @popular_categories = Category.limit(4).order("RANDOM()")

    @features = [
      { title: "Fast Delivery", description: "1-3 days.", icon: "truck" },
      { title: "Money-back guarantee", description: "Within 10 days.", icon: "banknotes" },
      { title: "Pro Quality Support", description: "24/7 live support.", icon: "phone" },
      { title: "Secure payment", description: "SSL.", icon: "shield-check" }
    ]

    @select_products = Product.limit(12).order("RANDOM()")

    @testimonials = [
      {
        content: "I love shopping on Ecom. They have the best products and the best prices. I would recommend them to anyone looking for a great shopping experience.",
        author: "John Doe",
        image: "https://placehold.co/100/000000/FFF",
        title: "Regular Customer"
      },
      {
        content: "Ecom has changed the way I shop online. Their selection is amazing and their prices are unbeatable.",
        author: "Jane Smith",
        image: "https://placehold.co/100/000000/FFF",
        title: "Frequent Buyer"
      },
      {
        content: "I had a great experience shopping on Ecom. The website is easy to use and the products are top-notch.",
        author: "Alice Johnson",
        image: "https://placehold.co/100/000000/FFF",
        title: "Satisfied Customer"
      },
      {
        content: "Ecom is my go-to online store. They have everything I need and their customer service is excellent.",
        author: "Bob Brown",
        image: "https://placehold.co/100/000000/FFF",
        title: "Loyal Customer"
      }
    ].shuffle

    @footer_links = {
      "app" => [
        {
          image_file: "apple-store-logo.png",
          title: "Apple Store Logo",
          path: "https://apps.apple.com/app/ecom/id123456789"
        },
        {
          image_file: "google-play-logo.png",
          title: "Google Play Logo",
          path: "https://play.google.com/store/apps/details?id=com.ecom"
        }
      ],
      "customer" => [
        { name: "Account", path: "#" },
        { name: "Help Center", path: "#" },
        { name: "Delivery Information", path: "#" },
        { name: "Terms of Service", path: "#" },
        { name: "Privacy Policy", path: "#" }
      ],
      "company" => [
        { name: "About Us", path: "#" },
        { name: "Contact Us", path: "#" },
        { name: "Frequently Asked Questions", path: "#" },
        { name: "Careers", path: "#" },
        { name: "Blog", path: "#" }
      ],
      "social" => [
        { name: "Facebook", path: "#", icon: "icons8-facebook", handle: "@ecom_superstore" },
        { name: "x", path: "#", icon: "icons8-x", handle: "@ecom_on_x" },
        { name: "Instagram", path: "#", icon: "icons8-instagram", handle: "@ecom_insta" },
        { name: "LinkedIn", path: "#", icon: "icons8-linkedin", handle: "@ecom_linkedin" },
        { name: "YouTube", path: "#", icon: "icons8-youtube", handle: "@ecom_youtube" }
      ],
      "payment" => [
        { name: "Visa", image_file: "pay-visa-img.png" },
        { name: "MasterCard", image_file: "pay-mastercard-img.png" },
        { name: "PayPal", image_file: "pay-paypal-img.png" },
        { name: "Apple Pay", image_file: "pay-applepay-img.png" },
        { name: "Google Pay", image_file: "pay-googlepay-img.png" }
      ]
    }

    # Mock promotion data for the home page
    @promotion = {
      name: "Summer Sale",
      description: "Get ready for summer with our exclusive featured product. Limited time offer!",
      discount_rate: 20,
      start_date: Date.today,
      end_date: Date.today + 30.days,
      product: @hero_product
    }
  end
end
