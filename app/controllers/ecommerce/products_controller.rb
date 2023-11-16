require_dependency "ecommerce/application_controller"

module Ecommerce
  class ProductsController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}"
    skip_before_action :authenticate_user!
    before_action :set_product, only: [:show]
    before_action :set_facebook_locale, only: [:show]

    authorize_resource

    def index

      set_index_meta_tags

      if params[:search]
        if @banana_permission
          @products = Product.search_by_name(params[:search]).active.page(params[:page])
        else
          @products = Product.search_by_name(params[:search]).active_not_banana.page(params[:page])
        end
        render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index" and return
      end

      if params[:category_id]
        @category = Category.find(params[:category_id])
        #@child_categories = Category.where(parent_id: @category.id)
        Globalize.with_locale(Ecommerce.backoffice_default_locale) do
          @child_categories = Category.tagged_with(@category.name)
        end
        if @child_categories.count > 0
          redirect_to categories_path(parent_category: @category.id)
        else
          Globalize.with_locale(Ecommerce.backoffice_default_locale) do
            if @banana_permission
              @all_products = Product.includes(:translations).tagged_with(@category.name).active.order(:product_order)
              @products = Product.includes(:translations).tagged_with(@category.name).active.order(:product_order).page(params[:page])
            else
              @all_products = Product.includes(:translations).tagged_with(@category.name).active_not_banana.order(:product_order)
              @products = Product.includes(:translations).tagged_with(@category.name).active_not_banana.order(:product_order).page(params[:page])
            end
          end
          render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
        end
      else
        if @banana_permission
          @all_products = Product.all.includes(:translations).active.order(:product_order)
          @products = Product.all.includes(:translations).active.order(:product_order).page(params[:page])
        else
          @all_products = Product.all.includes(:translations).active_not_banana.order(:product_order)
          @products = Product.all.includes(:translations).active_not_banana.order(:product_order).page(params[:page])
        end
        render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
      end
    end

    def show
      #set_controller_meta_tags(action_name)

      @cart_item = CartItem.new
      @wishlist_item = CartItem.new

      @related_products = Ecommerce::Product.where(category_id: @product.category_id).active.order(:product_order).limit(20)

      set_show_meta_tags

      render "ecommerce/#{Ecommerce.ecommerce_layout}/product/show"
    end

    def favorites
      if Ecommerce::Order.where(user_id: current_user.id).count > 0
        user_orders_items = Ecommerce::OrderItem.where(order_id: current_user.user_orders.pluck(:id)).group(:product_id).order('COUNT(*) DESC').select('product_id').pluck(:product_id)
        @products = Product.where(id: user_orders_items).includes(:translations).order(:product_order).active.page(params[:page])
        render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
      else
        redirect_back fallback_location: root_path
      end
    end

    def search
      redirect_to products_path(search: params[:search])
    end

    def stock_alert
      if current_user
        @product = Ecommerce::Product.find(params[:stock_alert][:product_id])
        stock_alert_exists = Ecommerce::StockAlert.find_by(user_id: current_user.id, product_id: @product.id)
        if stock_alert_exists
          stock_alert_exists.update(status: 0)
        else
          Ecommerce::StockAlert.create(user_id: current_user.id, product_id: @product.id, status: 0)
        end
        respond_to do |format|
          format.js { flash.now[:notice] = "NOW_FLASH_#{t('.stock_alert_set')}"; render "ecommerce/#{Ecommerce.ecommerce_layout}/product/stock_alert"  }

          format.html {redirect_to product_path(@product) }
        end
      else
        respond_to do |format|
          format.js { flash.now[:notice] = "NOW_FLASH_#{t('.stock_alert_set')}"; render "ecommerce/#{Ecommerce.ecommerce_layout}/product/stock_alert_signed_out"  }

          format.html {redirect_to product_path(@product) }
        end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_product
        @product = Product.friendly.find(params[:id])
      end

      def set_facebook_locale
        case I18n.locale[0..1]
        when 'en'
          @fb_compatible_locale_code = 'en_US'
        when 'es'
          @fb_compatible_locale_code = 'es_LA'
        else
          @fb_compatible_locale_code = 'es_LA'
        end
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def product_params
        params.require(:address).permit(:name, :tag_list, :coupon, :coupon_id)
      end

      def set_show_meta_tags
        set_meta_tags title: @product.name,
                      description: @product.description,
                      og: {
                        title: "#{@product.name} | #{Ecommerce.site_name}", #TODO change this to global value to save a db call
                        description:    @product.description,
                        image:    @product.image.medium_400.url
                      }
      end

      def set_index_meta_tags
        set_meta_tags title: "Products",
                      description: "ExpatShop Product List",
                      og: {
                        title:    :full_title,
                        image:    Ecommerce.logo
                      }
      end

  end
end
