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
    if customer_email.present?
      customer_email.split("@").first.titleize
    else
      "Unknown Customer"
    end
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

  def self.ransackable_attributes(auth_object = nil)
    [ "address", "created_at", "customer_email", "fulfilled", "id", "total", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "order_products", "products" ]
  end
end
