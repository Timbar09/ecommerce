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
  end
end
