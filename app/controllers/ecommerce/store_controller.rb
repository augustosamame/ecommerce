require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class StoreController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}/"
    before_action :set_menu_items
    skip_before_action :authenticate_user!

    def main
      add_body_css_class('stretched')
      render "ecommerce/#{Ecommerce.ecommerce_layout}/store/main"
    end

    def shop_by_category
      @products = Ecommerce::Product.where(category_id: params[:id])
      render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
    end

    private

      def set_menu_items
        @top_bar_new_hash = Ecommerce::Control.find_by(name: 'top_bar_cookie_read_hash').text_value #this will be set as a cookie via javascript if user closes top_bar
        @secondary_menu_categories = Ecommerce::Category.where(main_menu: true, category_type: "secondary", status: "active").order(:category_order)
        @homepage_categories = Ecommerce::Category.where(popular_homepage: true, status: "active").order(:category_order)
      end

  end
end
