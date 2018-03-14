require_dependency "ecommerce/application_controller"

module Ecommerce
  class ProductsController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}"
    skip_before_action :authenticate_user!
    before_action :set_product, only: [:show]
    before_action :set_facebook_locale, only: [:show]

    def index
      if params[:category_id]
        @category = Category.find(params[:category_id])
        @products = Product.tagged_with(@category.name)
      else
        @products = Product.all
      end

      set_index_meta_tags

      render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
    end

    def show

      #set_controller_meta_tags(action_name)

      @cart_item = CartItem.new
      @wishlist_item = CartItem.new

      set_show_meta_tags

      render "ecommerce/#{Ecommerce.ecommerce_layout}/product/show"
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_product
        @product = Product.find(params[:id])
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
        params.require(:address).permit(:name, :tag_list)
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
