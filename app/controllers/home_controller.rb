class HomeController < ApplicationController
  include RansackSearchable

  def index
    ransack_query(Product)
    @products = @q.result(distinct: true)
    @categories = Category.all

    @hero_product = Product.find_by(id: 8) || Product.first
    @hero_product_category = @hero_product.category

    @side_product = Product.find_by(id: 5) || Product.last
  end
end
