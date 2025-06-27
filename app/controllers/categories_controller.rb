class CategoriesController < ApplicationController
  include RansackSearchable
  def show
    @category = Category.find(params[:id])

    ransack_query(Product, { category_id_eq: @category.id })
    @products = @q.result(distinct: true)
  end
end
