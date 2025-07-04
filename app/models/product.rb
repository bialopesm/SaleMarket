class Product < ApplicationRecord
  # Tipos de promoção possíveis:
  # 'bogo' => Buy One Get One Free
  # 'bulk_price' => Preço especial para quantidade mínima
  # 'bulk_discount' => Desconto percentual para quantidade mínima

  def calculate_subtotal(quantity)
    case promotion_type
    when 'bogo'
      # Buy 1 Get 1 Free
      paid = (quantity / 2.0).ceil
      paid * price
    when 'bulk_price'
      # Preço especial para quantidade mínima
      min_qty = promotion_value.to_i # Ex: 3
      special_price = promotion_value.to_f # Ex: 4.50
      if quantity >= min_qty
        quantity * special_price
      else
        quantity * price
      end
    when 'bulk_discount'
      # Desconto percentual para quantidade mínima
      min_qty = promotion_value.to_i # Ex: 3
      discount = promotion_value.to_f # Ex: 0.33 (33%)
      if quantity >= min_qty
        quantity * price * (1 - discount)
      else
        quantity * price
      end
    else
      quantity * price
    end
  end
end
