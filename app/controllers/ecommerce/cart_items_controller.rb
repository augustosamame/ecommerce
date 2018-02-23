require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class CartItemsController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}/"
    skip_before_action :authenticate_user!
    before_action :set_cart, only: [:create, :destroy]

    def create
      byebug
      @cart.add_cart_items(cart_item_params)

      if @cart.save
        redirect_to cart_path(@cart)
      else
        flash[:error] = "There was a problem adding this item to your cart"
        redirect_to @product
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
      render "ecommerce/store/#{Ecommerce.ecommerce_layout}/product_detail"
    end

    private

      def set_menu_items
        @top_bar_new_hash = Ecommerce::Control.find_by(name: 'top_bar_cookie_read_hash').text_value #this will be set as a cookie via javascript if user closes top_bar
        @home_menu_categories = Ecommerce::Category.where(main_menu: true, status: "active").order(:category_order)
        @homepage_categories = Ecommerce::Category.where(popular_homepage: true, status: "active").order(:category_order)
      end

  end
end
