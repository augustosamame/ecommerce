require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class StoreController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}/"
    before_action :set_home_items
    skip_before_action :authenticate_user!

    def main

      set_main_meta_tags

      #Featured products are available site wide so will be a default instance variable
      featured_products_category_id = Rails.env.production? ? 64 : 11
      featured_produts_category = Category.find(featured_products_category_id)
      Globalize.with_locale('en-PE') do
        @featured_products = Product.includes(:translations).tagged_with(featured_produts_category.name).active.order(:product_order).page(params[:page])
      end
      if params[:search]
        @products = Product.search_by_name(params[:search]).active.page(params[:page])
        render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index" and return
      end
      @home_brands = Brand.where(featured: true)
      @featured_homepage_products = Ecommerce::Product.where(home_featured: true).order(:id).active
      @homepage_categories = Ecommerce::Category.where(popular_homepage: true, status: "active").order(:category_order)
      @mobile_slider_array = Ecommerce::Slider.where(slider_view: "MOBILE").order(:slider_order).pluck(:slider_link).to_json
      @desktop_slider_array = Ecommerce::Slider.where(slider_view: "DESKTOP").order(:slider_order).pluck(:slider_link).to_json
      add_body_css_class('stretched')
      render "ecommerce/#{Ecommerce.ecommerce_layout}/store/main"
    end

    def about_us
      render "ecommerce/#{Ecommerce.ecommerce_layout}/store/about_us"
    end

    def shipping_policy
      render "ecommerce/#{Ecommerce.ecommerce_layout}/store/shipping_policy"
    end

    def contact_us
      @contact_message = Ecommerce::ContactMessage.new
      render "ecommerce/#{Ecommerce.ecommerce_layout}/store/contact_us"
    end

    def terms_and_conditions
      render "ecommerce/#{Ecommerce.ecommerce_layout}/store/terms_and_conditions"
    end

    def post_contact_us
      AdminMailer.contact_us_email(params[:contact_message][:name], params[:contact_message][:email], params[:contact_message][:phone], params[:contact_message][:message]).deliver_later!# unless Rails.env == "development"
      redirect_back fallback_location: contact_us_path, notice: "Thank you for your message. We will be in touch soon"
    end

    def wishlist
      @wishlist_message = Ecommerce::WishlistMessage.new
      render "ecommerce/#{Ecommerce.ecommerce_layout}/store/wishlist"
    end

    def post_wishlist
      wishparams = params[:wishlist_message]
      @wishlist_message = Ecommerce::WishlistMessage.new(name: wishparams[:name], email: wishparams[:email], phone: wishparams[:phone], product_name: wishparams[:product_name], brand: wishparams[:brand], attributes: wishparams[:attributes], country: wishparams[:country], comment: wishparams[:comment])
      if @wishlist_message.valid?
        if current_user
          AdminMailer.wishlist_email(current_user.name, current_user.email, current_user.username, wishparams[:product_name], wishparams[:brand], wishparams[:attributes], wishparams[:country], wishparams[:comment]).deliver_later!# unless Rails.env == "development"
        else
          AdminMailer.wishlist_email(wishparams[:name], wishparams[:email], wishparams[:phone], wishparams[:product_name], wishparams[:brand], wishparams[:attributes], wishparams[:country], wishparams[:comment]).deliver_later!# unless Rails.env == "development"
        end
        redirect_back fallback_location: wishlist_message_path, notice: "Thank you letting us know your wish. We'll be in touch soon"
      else
        flash[:error] = "Wishlist missing a required field"
        render "ecommerce/#{Ecommerce.ecommerce_layout}/store/wishlist"
      end
    end

    def shop_by_category
      @products = Ecommerce::Product.where(category_id: params[:id]).active.order(:product_order)
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
        Globalize.with_locale(Ecommerce.backoffice_default_locale) do
          @categories = Category.active.tagged_with(@category.name).order(:category_order)
        end
        if @categories.count > 0
          render "ecommerce/#{Ecommerce.ecommerce_layout}/store/sub_categories_mobile"
          #redirect_to categories_m_path(category: @category.id)
        else
          Globalize.with_locale(Ecommerce.backoffice_default_locale) do
            @products = Product.tagged_with(@category.name).order(:product_order).active.page(params[:page])
          end
          render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
        end
      else
        @products = Product.all.order(:product_order).active.order(:product_order).page(params[:page])
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
