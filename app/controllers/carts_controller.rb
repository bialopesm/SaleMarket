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
    if request.xhr? || request.format.json?
      head :ok
    else
      redirect_to root_path, notice: 'Produto adicionado ao carrinho.'
    end
  end

  def remove_item
    item = @cart.cart_items.find_by(product_id: params[:product_id])
    item.destroy if item
    if request.xhr? || request.format.json?
      render json: { success: true, message: 'Produto removido do carrinho.' }
    else
      redirect_to root_path, notice: 'Produto removido do carrinho.'
    end
  end

  def empty_cart
    @cart.cart_items.destroy_all
    if request.xhr? || request.format.json?
      render json: { success: true, message: 'Carrinho esvaziado.' }
    else
      redirect_to root_path, notice: 'Carrinho esvaziado.'
    end
  end

  def update_item
    item = @cart.cart_items.find_by(product_id: params[:product_id])
    if item && params[:quantity].to_i > 0
      item.update(quantity: params[:quantity].to_i)
      message = 'Quantidade atualizada.'
      success = true
    elsif item && params[:quantity].to_i <= 0
      item.destroy
      message = 'Produto removido do carrinho.'
      success = true
    else
      message = 'Item não encontrado.'
      success = false
    end

    if request.xhr? || request.format.json?
      render json: { success: success, message: message }
    else
      redirect_to root_path, notice: message
    end
  end

  private

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id]) || Cart.create
    session[:cart_id] = @cart.id
  end
end
