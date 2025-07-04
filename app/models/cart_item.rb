class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  def subtotal
    product.calculate_subtotal(quantity)
  end
end
