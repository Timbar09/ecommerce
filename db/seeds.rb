# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# # Create 12 new orders
# (1..12).each do |i|
#   Order.create!(
#     customer_email: Faker::Internet.email,
#     total: Faker::Number.between(from: 700, to: 3500),
#     fulfilled: [ true, false ].sample,
#     address: Faker::Address.full_address,
#     created_at: Faker::Date.between(from: 10.days.ago, to: 5.days.from_now),
#     updated_at: Faker::Date.between(from: 10.days.ago, to: 5.days.from_now)
#   )
# end
