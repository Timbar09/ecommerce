class Order < ApplicationRecord
  def display_sku
    "order0#{id}"
  end

  def display_fulfilled
    fulfilled ? "Yes" : "No"
  end
end
