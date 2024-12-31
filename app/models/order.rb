class Order < ApplicationRecord
  has_many :order_products
  has_many :products, through: :order_products

  def display_id
    id_str = id.to_s
    "##{id_str.rjust(9, '0')}"
  end

  def display_fulfilled
    fulfilled ? "Fulfilled" : "Pending"
  end
end
