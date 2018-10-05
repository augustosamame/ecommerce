require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::TranslationsController < Backoffice::BaseController
    #before_action :set_backoffice_, only: [:show, :edit, :update, :best_in_place_update, :destroy]
    authorize_resource :class => false

    # GET /backoffice/translations
    def index
      @category_name = Category.all.order(:category_type, :category_order, :id)
      @category_overlay = Category.all.order(:category_type, :category_order, :id)
      @product_name = Product.all.order(:product_order, id: :desc)
      @product_short_description = Product.all.order(:product_order, id: :desc)
      @product_description = Product.all.order(:product_order, id: :desc)
    end

    # GET /backoffice/translations/1
    def show
    end

    private
      # Use callbacks to share common setup or constraints between actions.

      # Only allow a trusted parameter "white list" through.
      def backoffice_translation_params
        params.require(:translation).permit(:id)
      end
  end
end
