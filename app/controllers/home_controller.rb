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
  end
end
