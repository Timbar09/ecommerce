class Category < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 50, 50 ]
    attachable.variant :medium, resize_to_limit: [ 250, 250 ]
  end

  has_many :products, dependent: :destroy

  def display_thumb_image
    if respond_to?(:image) && image.attached?
      image.variant(:thumb)
    else
      "https://via.placeholder.com/50"
    end
  end

  def display_medium_image
    if respond_to?(:image) && image.attached?
      image.variant(:medium)
    else
      "https://via.placeholder.com/250"
    end
  end
end
