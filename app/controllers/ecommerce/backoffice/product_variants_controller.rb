require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::ProductVariantsController < Backoffice::BaseController
    before_action :set_backoffice_product_variant, only: [:show, :edit, :update, :destroy]
    authorize_resource

    # GET /backoffice/product_variants
    def index
      @backoffice_product_variants = ProductVariant.all
    end

    # GET /backoffice/product_variants/1
    def show
    end

    # GET /backoffice/product_variants/new
    def new
      @backoffice_product_variant = ProductVariant.new
    end

    # GET /backoffice/product_variants/1/edit
    def edit
    end

    # POST /backoffice/product_variants
    def create
      @backoffice_product_variant = ProductVariant.new(backoffice_product_variant_params)

      if @backoffice_product_variant.save
        redirect_to @backoffice_product_variant, notice: 'Product variant was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/product_variants/1
    def update
      if @backoffice_product_variant.update(backoffice_product_variant_params)
        redirect_to @backoffice_product_variant, notice: 'Product variant was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/product_variants/1
    def destroy
      @backoffice_product_variant.destroy
      redirect_to backoffice_product_variants_url, notice: 'Product variant was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_product_variant
        @backoffice_product_variant = ProductVariant.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_product_variant_params
        params.require(:backoffice_product_variant).permit(:product_id, :variant_name)
      end
  end
end
