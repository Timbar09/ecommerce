class Product < ApplicationRecord
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 50, 50 ]
  end

  belongs_to :category
  has_many :stocks, dependent: :destroy

  def display_thumb_image
    if respond_to?(:images) && images.any?
      images.first.variant(:thumb)
    else
      "https://via.placeholder.com/50"
    end
  end
end
