class Product < ApplicationRecord
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 50, 50 ]
    attachable.variant :small, resize_to_limit: [ 100, 100 ]
    attachable.variant :large, resize_to_limit: [ 500, 500 ]
  end

  belongs_to :category
  has_many :stocks, dependent: :destroy
  has_many :order_products
  has_many :orders, through: :order_products

  def display_id
    id_str = id.to_s
    "##{id_str.rjust(9, '0')}"
  end

  def display_thumb_image
    if respond_to?(:images) && images.any?
      images.first.variant(:thumb)
    else
      "https://via.placeholder.com/50"
    end
  end

  def display_small_image
    if respond_to?(:images) && images.any?
      images.first.variant(:small)
    else
      "https://via.placeholder.com/100"
    end
  end

  def display_large_image
    if respond_to?(:images) && images.any?
      images.first.variant(:large)
    else
      "https://via.placeholder.com/500"
    end
  end
end
