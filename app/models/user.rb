class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  ROLES = %w[user admin super_admin].freeze

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 50, 50 ]
    attachable.variant :medium, resize_to_limit: [ 150, 150 ]
  end

  def display_thumb_image
    avatar.attached? ? avatar.variant(:thumb) : "https://via.placeholder.com/50"
  end

  def display_small_image
    avatar.attached? ? avatar.variant(:thumb) : "https://via.placeholder.com/100"
  end

  def display_medium_image
    avatar.attached? ? avatar.variant(:medium) : "https://via.placeholder.com/250"
  end

  def display_full_name
    "#{first_name} #{last_name}".strip
  end
end
