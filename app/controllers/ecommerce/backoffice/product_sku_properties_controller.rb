require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::ProductSkuPropertiesController < Backoffice::BaseController
    before_action :set_backoffice_product_sku_property, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::ProductSkuProperty"

    # GET /backoffice/product_variant_values
    def index
      @backoffice_product_sku_properties = ProductSkuProperty.all
    end

    # GET /backoffice/product_variant_values/1
    def show
    end

    # GET /backoffice/product_variant_values/new
    def new
      @backoffice_product_sku_property = ProductSkuProperty.new
    end

    # GET /backoffice/product_variant_values/1/edit
    def edit
    end

    # POST /backoffice/product_variant_values
    def create
      @backoffice_product_sku_property = ProductSkuProperty.new(backoffice_product_sku_property_params)

      if @backoffice_product_sku_property.save
        redirect_to backoffice_product_sku_property_path(@backoffice_product_sku_property), notice: 'Product SKU property was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/product_variant_values/1
    def update
      if @backoffice_product_sku_property.update(backoffice_product_sku_property_params)
        redirect_to backoffice_product_sku_property_path(@backoffice_product_sku_property), notice: 'Product SKU property was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/product_variant_values/1
    def destroy
      @backoffice_product_sku_property.destroy
      redirect_to backoffice_product_sku_properties_url, notice: 'Product SKU property value was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_product_sku_property
        @backoffice_product_sku_property = ProductSkuProperty.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_product_sku_property_params
        params.require(:product_sku_property).permit(:product_sku_id, :product_variant_id, :value, :status)
      end
  end
end
