require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class CartItemsController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}/"
    skip_before_action :authenticate_user!
    before_action :set_menu_items
    before_action :set_cart_item, only: [:destroy]

    authorize_resource

    def create
      @cart_item = CartItem.new(cart_item_params)
      @cart_item.cart_id = @cart.id
      if @cart_item.save
        redirect_to cart_path(@cart) and return
      else
        flash[:error] = "There was a problem adding this item to your cart"
        @product = Product.find(@cart_item.product.id)
        redirect_to product_path(@product)
      end

      @product = Ecommerce::Product.find(params[:id])
      case I18n.locale[0..1]
      when 'en'
        @fb_compatible_locale_code = 'en_US'
      when 'es'
        @fb_compatible_locale_code = 'es_LA'
      else
        @fb_compatible_locale_code = 'es_LA'
      end
      render "ecommerce/#{Ecommerce.ecommerce_layout}/product/show"
    end

    def edit
      @cart_item.update(cart_item_params)
      redirect_to @cart_item.cart, notice: 'Cart edited.'
    end

    def destroy
      @cart_item.destroy
      redirect_to @cart_item.cart, notice: 'Item deleted.'
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
