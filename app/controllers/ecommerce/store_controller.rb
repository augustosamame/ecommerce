require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class StoreController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}/"
    before_action :set_home_items
    skip_before_action :authenticate_user!

    def main

      set_main_meta_tags

      if params[:search]
        @products = Product.search_by_name(params[:search]).active.page(params[:page])
        render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index" and return
      end
      @home_brands = Brand.where(featured: true)
      @featured_homepage_products = Ecommerce::Product.where(home_featured: true).order(:id).active
      @homepage_categories = Ecommerce::Category.where(popular_homepage: true, status: "active").order(:category_order)
      add_body_css_class('stretched')
      render "ecommerce/#{Ecommerce.ecommerce_layout}/store/main"
    end

    def shop_by_category
      @products = Ecommerce::Product.where(category_id: params[:id]).active
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

    def sub_categories_mobile
      if params[:parent_category]
        @category = Category.find(params[:parent_category])
        @categories = Category.tagged_with(@category.name)
        if @categories.count > 0
          render "ecommerce/#{Ecommerce.ecommerce_layout}/store/sub_categories_mobile"
          #redirect_to categories_m_path(category: @category.id)
        else
          @products = Product.tagged_with(@category.name).order(:product_order).active.page(params[:page])
          render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
        end
      else
        @products = Product.all.order(:product_order).active.page(params[:page])
        render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
      end
    end

    private

      def set_home_items
        @top_bar_new_hash = Ecommerce::Control.find_by(name: 'top_bar_cookie_read_hash').text_value #this will be set as a cookie via javascript if user closes top_bar
        @secondary_menu_categories = Ecommerce::Category.where(main_menu: true, category_type: "secondary", status: "active").order(:category_order)
      end

      def set_main_meta_tags
        set_meta_tags title: "Home",
                      description: "ExpatShop Perú - your one stop shop for products from all the world to Perú",
                      og: {
                        title:    :full_title,
                        image:    Ecommerce.logo
                      }
      end

  end
end
