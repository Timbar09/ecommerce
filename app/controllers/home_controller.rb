class HomeController < ApplicationController
  include RansackSearchable

  def index
    ransack_query(Product)
    @products = @q.result(distinct: true)
    @categories = Category.all
  end
end
