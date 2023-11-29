require_dependency "ecommerce/application_controller"

module Ecommerce
  class CartsController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :set_cart, only: [:show, :edit, :update, :destroy]

    authorize_resource

    # GET /carts/1
    def show
      @cart_qty_subtotal = @cart.cart_items.includes(:product).sum(:quantity)
      @cart_subtotal = 0
      @cart.cart_items.includes(:product).each do |cart_item|
        @cart_subtotal += cart_item.line_total(current_user)
      end
      if @combo_total_discount_usd && @combo_total_discount_usd > 0
        money_object_discount = Money.new(@combo_total_discount_usd * 100, 'PEN')
        @cart_subtotal_after_discount = @cart_subtotal - money_object_discount
      end
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
        @cart_item_qty_total = @cart.cart_items.sum(&:quantity)
      end

      # Only allow a trusted parameter "white list" through.
      def cart_params
        params.require(:cart).permit(:user_id, :status)
      end
  end
end
