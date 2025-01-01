class Order < ApplicationRecord
  has_many :order_products
  has_many :products, through: :order_products

  def display_id
    id_str = id.to_s
    "##{id_str.rjust(9, '0')}"
  end

  def display_name
    "John Doe"
  end

  def display_fulfilled
    fulfilled ? "Fulfilled" : "Pending"
  end

  def display_order_date
    created_at.strftime("%B %d, %Y")
  end

  def display_delivery_date
    date = created_at + 2.weeks
    date.strftime("%B %d, %Y")
  end
end
