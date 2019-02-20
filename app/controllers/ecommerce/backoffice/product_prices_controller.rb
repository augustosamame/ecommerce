require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::ProductPricesController < Backoffice::BaseController
    before_action :set_product_price, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::ProductPrice"

    # GET /product_prices
    def index
      @product_prices = ProductPrice.all
    end

    # GET /product_prices/1
    def show
    end

    # GET /product_prices/new
    def new
      @product_price = ProductPrice.new
    end

    # GET /product_prices/1/edit
    def edit
    end

    # POST /product_prices
    def create
      @product_price = ProductPrice.new(product_price_params)

      if @product_price.save
        redirect_to [:backoffice, @product_price], notice: 'Product Price was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /product_prices/1
    def update
      if @product_price.update(product_price_params)
        redirect_to [:backoffice, @product_price], notice: 'Product Price was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /product_prices/1
    def destroy
      @product_price.destroy
      redirect_to backoffice_product_prices_url, notice: 'Product Price was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_product_price
        @product_price = ProductPrice.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def product_price_params
        params.require(:product_price).permit(:product, :product_id, :pricelist, :pricelist_id, :price, :price_cents, :discounted_price, :discounted_price_cents, :usd_price, :usd_price_cents, :usd_discounted_price, :usd_discounted_price_cents)
      end
  end
end
