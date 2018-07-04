require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class CartItemsController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}/"
    skip_before_action :authenticate_user!
    before_action :set_menu_items
    before_action :set_cart_item, only: [:destroy, :update]

    authorize_resource

    respond_to :html, :js

    def create
      @cart_item = CartItem.new(cart_item_params)
      @cart_item.cart_id = @cart.id
      found_same_product = @cart.cart_items.find_by(product_id: @cart_item.product_id)
      if found_same_product
        found_same_product.update(quantity: found_same_product.quantity += @cart_item.quantity)
      else
        @cart_item.save
      end
      #refresh with latest cart so it will be repainted properly
      set_cart
      respond_to do |format|
        format.js { render "ecommerce/#{Ecommerce.ecommerce_layout}/cart_items/show"  }

        format.html {redirect_to cart_path(@cart) }
      end
    end

    def update
      @cart_item.update(quantity: cart_item_params[:quantity]) unless cart_item_params[:quantity].nil?
      redirect_to @cart_item.cart, notice: 'Cart updated.'
    end

    def destroy
      @cart_item.destroy
      set_cart
      respond_to do |format|
        format.js { render "ecommerce/#{Ecommerce.ecommerce_layout}/cart_items/show" }
        format.html {redirect_to cart_path(@cart), notice: 'Item deleted.' }
      end
    end

    private

      def set_cart_item
        @cart_item = CartItem.find(params[:id])
      end

      def set_menu_items
        @top_bar_new_hash = Ecommerce::Control.find_by(name: 'top_bar_cookie_read_hash').text_value #this will be set as a cookie via javascript if user closes top_bar
        @primary_menu_categories = Ecommerce::Category.where(main_menu: true, category_type: "primary", status: "active").order(:category_order)
        @secondary_menu_categories = Ecommerce::Category.where(main_menu: true, category_type: "secondary", status: "active").order(:category_order)
        @homepage_categories = Ecommerce::Category.where(popular_homepage: true, status: "active").order(:category_order)
      end

      def cart_item_params
        params.require(:cart_item).permit(:cart_id, :product_id, :quantity, :status)
      end

  end
end
