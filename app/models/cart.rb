class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  def total
    cart_items.includes(:product).sum do |item|
      item.subtotal
    end
  end
end
