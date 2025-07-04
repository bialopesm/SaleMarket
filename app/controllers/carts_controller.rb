class CartsController < ApplicationController
  before_action :set_cart

  def show
  end

  def add_item
    product = Product.find(params[:product_id])
    item = @cart.cart_items.find_or_initialize_by(product: product)
    item.quantity ||= 0
    item.quantity += params[:quantity].to_i > 0 ? params[:quantity].to_i : 1
    item.save!
    redirect_to root_path, notice: 'Produto adicionado ao carrinho.'
  end

  def remove_item
    item = @cart.cart_items.find_by(product_id: params[:product_id])
    item.destroy if item
    redirect_to cart_path, notice: 'Produto removido do carrinho.'
  end

  def empty_cart
    @cart.cart_items.destroy_all
    redirect_to cart_path, notice: 'Carrinho esvaziado.'
  end

  private

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id]) || Cart.create
    session[:cart_id] = @cart.id
  end
end
