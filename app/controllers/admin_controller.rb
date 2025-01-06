class AdminController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_admin, only: %i[ show ]

  def index
    @admins = Admin.all
    @orders = Order.where(fulfilled: false).order(created_at: :desc).take(5)
    @quick_stats = [
      { title: "Sales", icon: "cart", value: Order.where(created_at: Time.now.midnight..Time.now).count },
      { title: "Revenue", icon: "credit-card", value: Order.where(created_at: Time.now.midnight..Time.now).sum(:total).to_f.round },
      { title: "Average Sale", icon: "document-currency", value: Order.where(created_at: Time.now.midnight..Time.now).average(:total).to_f.round },
      { title: "Per Sale", icon: "currency-dollar", value: OrderProduct.joins(:order).where(orders: { created_at: Time.now.midnight..Time.now }).average(:quantity).to_f.round }
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
  end

  def show
  end

  private

  def set_admin
    @admin = Admin.find(current_admin.id)
  end
end
