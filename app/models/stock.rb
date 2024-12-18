class Stock < ApplicationRecord
  belongs_to :product

  ALLOWED_SIZES = %w[XS S M L XL XXL XXXL].freeze

  validates :size, presence: true
  validate :size_must_be_string_or_number
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  private

  def size_must_be_string_or_number
    unless size.is_a?(Numeric) || (size.is_a?(String) && ALLOWED_SIZES.include?(size.upcase))
      errors.add(:size, "must be a number or a string of the following values: #{ALLOWED_SIZES.join(', ')}")
    end
  end
end
