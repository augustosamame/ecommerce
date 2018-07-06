require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class StoreController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}/"
    before_action :set_home_items
    skip_before_action :authenticate_user!

    def main
      @home_brands = Brand.where(featured: true)
      @featured_homepage_products = Ecommerce::Product.where(home_featured: true).order(:id).in_stock
      @homepage_categories = Ecommerce::Category.where(popular_homepage: true, status: "active").order(:category_order)
      add_body_css_class('stretched')
      render "ecommerce/#{Ecommerce.ecommerce_layout}/store/main"
    end

    def shop_by_category
      @products = Ecommerce::Product.where(category_id: params[:id]).in_stock
      render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
    end

    def houses_mobile
      add_body_css_class('stretched')
      render "ecommerce/#{Ecommerce.ecommerce_layout}/store/houses_mobile"
    end

    def categories_mobile
      add_body_css_class('stretched')
      render "ecommerce/#{Ecommerce.ecommerce_layout}/store/categories_mobile"
    end

    private

      def set_home_items
        @top_bar_new_hash = Ecommerce::Control.find_by(name: 'top_bar_cookie_read_hash').text_value #this will be set as a cookie via javascript if user closes top_bar
        @secondary_menu_categories = Ecommerce::Category.where(main_menu: true, category_type: "secondary", status: "active").order(:category_order)
      end

  end
end
