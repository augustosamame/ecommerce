require_dependency "ecommerce/application_controller"

module Ecommerce
  class CartsController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :set_cart, only: [:show, :edit, :update, :destroy]

    authorize_resource

    # GET /carts/1
    def show
      @cart_qty_subtotal = @cart.cart_items.includes(:product).sum(:quantity)
      @cart_subtotal = @cart.cart_items.includes(:product).sum(&:line_total)  #different syntax as line_total is not a db column but method
      render "ecommerce/#{Ecommerce.ecommerce_layout}/cart/show"
    end

    # GET /carts/1/edit
    def edit
    end

    # PATCH/PUT /carts/1
    def update
      if @cart.update(cart_params)
        redirect_to @cart, notice: 'Cart was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /carts/1
    def destroy
      @cart.destroy
      redirect_to carts_url, notice: 'Cart was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_cart
        @cart = Cart.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def cart_params
        params.require(:cart).permit(:user_id, :status)
      end
  end
end
