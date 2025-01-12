class Order < ApplicationRecord
  has_many :order_products
  has_many :products, through: :order_products

  def display_id
    id_str = id.to_s
    "##{id_str.rjust(9, '0')}"
  end

  def display_thumb_image
    "https://placehold.co/30x30/CCC/FFF"
  end

  def display_customer_name
    customer_email.split("@").first.titleize
  end

  def display_name
    customer_email.split("@").first.titleize
  end

  def display_fulfilled
    fulfilled ? "Fulfilled" : "Pending"
  end

  def display_order_date
    created_at.strftime("%b %d, %Y")
  end

  def display_delivery_date
    date = created_at + 2.weeks
    date.strftime("%B %d, %Y")
  end
end
