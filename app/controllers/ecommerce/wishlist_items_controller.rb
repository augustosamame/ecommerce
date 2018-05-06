require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class WishlistItemsController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}/"
    skip_before_action :authenticate_user!
    before_action :set_wishlist, only: [:create, :destroy]

    authorize_resource

    def create
      @wishlist_item = WishlistItem.new(wishlist_item_params)
      @wishlist_item.wishlist_id = @wishlist.id
      if @wishlist_item.save
        redirect_to wishlist_path(@wishlist) and return
      else
        flash[:error] = "There was a problem adding this item to your wishlist"
        @product = Product.find(@wishlist_item.product.id)
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

    private

      def set_menu_items
        @top_bar_new_hash = Ecommerce::Control.find_by(name: 'top_bar_cookie_read_hash').text_value #this will be set as a cookie via javascript if user closes top_bar
        @primary_menu_categories = Ecommerce::Category.where(main_menu: true, category_type: "primary", status: "active").order(:category_order)
        @secondary_menu_categories = Ecommerce::Category.where(main_menu: true, category_type: "secondary", status: "active").order(:category_order)
        @homepage_categories = Ecommerce::Category.where(popular_homepage: true, status: "active").order(:category_order)
      end

      def wishlist_item_params
        params.require(:wishlist_item).permit(:wishlist_id, :product_id, :quantity, :status)
      end

  end
end
