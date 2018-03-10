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
      render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
    end

    def show
      @cart_item = CartItem.new
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

  end
end
