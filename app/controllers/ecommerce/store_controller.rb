require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class StoreController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}/"
    before_action :set_menu_items
    skip_before_action :authenticate_user!

    def main
      add_body_css_class('stretched')
      render "ecommerce/store/#{Ecommerce.ecommerce_layout}/main"
    end

    def shop_by_category
      @category = Ecommerce::Category.find(params[:format])
      @products = Ecommerce::Product.where(category_id: params[:format])
      render "ecommerce/store/#{Ecommerce.ecommerce_layout}/shop_by_category"
    end

    def product_detail
      @product = Ecommerce::Product.find(params[:format])
      render "ecommerce/store/#{Ecommerce.ecommerce_layout}/product_detail"
    end

    private

      def set_menu_items
        @top_bar_new_hash = Ecommerce::Control.find_by(name: 'top_bar_cookie_read_hash').text_value #this will be set as a cookie via javascript if user closes top_bar
        @home_menu_categories = Category.where(main_menu: true, status: "active").order(:category_order)
        @homepage_categories = Ecommerce::Category.where(popular_homepage: true, status: "active").order(:category_order)
      end

  end
end
