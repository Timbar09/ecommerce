class AdminController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_admin, only: %i[ show ]

  def index
    @admins = Admin.all
    @orders = Order.where(fulfilled: false).order(created_at: :desc).take(5)

    @quick_stats = [
      { title: "Sales", icon: "credit-card", value: Order.where(created_at: Time.now.midnight..Time.now).count },
      { title: "Revenue", icon: "currency-dollar", value: Order.where(created_at: Time.now.midnight..Time.now).sum(:total).to_f.round },
      { title: "Average Sale", icon: "document-currency", value: Order.where(created_at: Time.now.midnight..Time.now).average(:total).to_f.round },
      { title: "Products / Sale", icon: "cube", value: OrderProduct.joins(:order).where(orders: { created_at: Time.now.midnight..Time.now }).average(:quantity).to_f.round }
    ]

    @orders_by_day = Order.where("created_at >= ?", 1.week.ago).order(:created_at).group_by { |order| order.created_at.to_date }
    @revenues_by_day = @orders_by_day.map do |day, orders|
      [ day.strftime("%A"), orders.sum(&:total) ]
    end
    if @revenues_by_day.length < 7
      days_of_the_week = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]

      data_hash = @revenues_by_day.to_h
      current_day = Time.now.strftime("%A")
      current_day_index = days_of_the_week.index(current_day)
      next_day_index = (current_day_index + 1) % days_of_the_week.length

      ordered_days_with_current_last = days_of_the_week[current_day_index..-1] + days_of_the_week[0...next_day_index]

      complete_ordered_array_with_current_last = ordered_days_with_current_last.map do |day|
        [ day, data_hash.fetch(day, 0) ]
      end

      @revenues_by_day = complete_ordered_array_with_current_last
    end

    @order_headers = [ :id, :name, :created_at, :total ]
    @order_actions = [ { path: ->(order) { admin_order_path(order) }, name: "View Order" } ]

    @products_by_price_range = Product.all.group_by { |product| product.price.to_i / 50 }.map do |price_range, products|
      [ "#{price_range * 50} - #{(price_range + 1) * 50}", products.count ]
    end

    # Mock sales data
    @sales_data = [
      [ "Jan", 5000 ],
      [ "Feb", 12000 ],
      [ "Mar", 10000 ],
      [ "Apr", 4000 ],
      [ "May", 7000 ],
      [ "Jun", 6000 ],
      [ "Jul", 1000 ],
      [ "Aug", 8000 ],
      [ "Sep", 9000 ],
      [ "Oct", 3000 ],
      [ "Nov", 11000 ],
      [ "Dec", 2000 ]
    ]
  end

  def show
  end

  private

  def set_admin
    @admin = Admin.find(current_admin.id)
  end
end
