class Stock < ApplicationRecord
  belongs_to :product

  ALLOWED_SIZES = %w[XS S M L XL XXL XXXL].freeze

  validates :size, presence: true
  validate :size_must_be_string_or_number
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def display_product_name
    "#{product.name} (#{product.category.name})"
  end

  def display_sku
    "stock0#{product.id}S0#{id}"
  end

  private

  def size_must_be_string_or_number
    processed_size = size
    if size.is_a?(String) && size.match?(/\A\d+\z/)
      processed_size = size.to_i
    end

    unless processed_size.is_a?(Numeric) || (processed_size.is_a?(String) && ALLOWED_SIZES.include?(processed_size.upcase))
      errors.add(:size, "must be a number or a string of the following values: #{ALLOWED_SIZES.join(', ')}. Got: #{processed_size.class}")
    end
  end
end
