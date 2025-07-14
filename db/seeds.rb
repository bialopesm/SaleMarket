# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Produtos principais do mercadinho
Product.find_or_create_by!(name: 'Chá Verde') do |p|
  p.price = 5.00
  p.promotion_type = 'bogo' # Compre 1 Leve 2
  p.promotion_value = nil
end

Product.find_or_create_by!(name: 'Café Torrado') do |p|
  p.price = 7.50
  p.promotion_type = 'bulk_price' # Preço especial em 3+
  p.promotion_value = 5.50 # R$ 5,50 cada em 3+
end

Product.find_or_create_by!(name: 'Biscoito Doce') do |p|
  p.price = 4.00
  p.promotion_type = 'bulk_discount' # 33% off em 3+
  p.promotion_value = 0.33 # 33% de desconto em 3+
end

puts 'Produtos em português atualizados!'
