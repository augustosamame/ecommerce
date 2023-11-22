require_dependency "ecommerce/application_controller"

module Ecommerce
  class BrandsController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}"
    skip_before_action :authenticate_user!
    before_action :set_facebook_locale, only: [:show]

    authorize_resource

    def show

      if params[:id]
        @products = Ecommerce::Product.includes(:translations).where(brand: params[:id]).active.order(:product_order).page(params[:page])
        @all_products = @products
        render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.

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

  end
end
