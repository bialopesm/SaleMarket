class ProductsController < ApplicationController
  def index
    @products = Product.all
    @cart = Cart.find_by(id: session[:cart_id]) || Cart.create
    session[:cart_id] = @cart.id
  end
end
