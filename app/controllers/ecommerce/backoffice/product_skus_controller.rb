require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::ProductSkusController < Backoffice::BaseController
    before_action :set_backoffice_product_sku, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::ProductSku"

    # GET /backoffice/product_skus
    def index
      @backoffice_product_skus = ProductSku.all
    end

    # GET /backoffice/product_skus/1
    def show
    end

    # GET /backoffice/product_skus/new
    def new
      @backoffice_product_sku = ProductSku.new
    end

    # GET /backoffice/product_skus/1/edit
    def edit
    end

    # POST /backoffice/product_skus
    def create
      @backoffice_product_sku = ProductSku.new(backoffice_product_sku_params)

      if @backoffice_product_sku.save
        redirect_to backoffice_product_sku_path(@backoffice_product_sku), notice: 'Product sku was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/product_skus/1
    def update
      if @backoffice_product_sku.update(backoffice_product_sku_params)
        redirect_to backoffice_product_sku_path(@backoffice_product_sku), notice: 'Product sku was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/product_skus/1
    def destroy
      @backoffice_product_sku.destroy
      redirect_to backoffice_product_skus_url, notice: 'Product sku was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_product_sku
        @backoffice_product_sku = ProductSku.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_product_sku_params
        params.require(:product_sku).permit(:product_id, :product_variant_value_id, :sku, :price_cents, :status)
      end
  end
end
