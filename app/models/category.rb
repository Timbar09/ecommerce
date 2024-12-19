class Category < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 50, 50 ]
  end

  has_many :products, dependent: :destroy

  def display_image
    if respond_to?(:image) && image.attached?
      image.variant(:thumb)
    elsif respond_to?(:images) && images.any?
      images.first.variant(:thumb)
    else
      "https://via.placeholder.com/50"
    end
  end
end
