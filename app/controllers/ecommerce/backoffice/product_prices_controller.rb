require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::ProductPricesController < Backoffice::BaseController
    before_action :set_product_price, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::ProductPrice"

    # GET /product_prices
    def index
      # Blank-until-filtered: pick a pricelist and only ITS rows render, then
      # add the products you want on it one by one — instead of dumping every
      # product price for every list (unusable at catalog size).
      @pricelists = Pricelist.all.order(:name)
      @selected_pricelist = Pricelist.find_by(id: params[:pricelist_id])
      @product_prices = if @selected_pricelist
        ProductPrice.where(pricelist_id: @selected_pricelist.id).includes(product: :translations)
      else
        ProductPrice.none
      end
    end

    # GET /product_prices/1
    def show
    end

    # GET /product_prices/new
    def new
      # Pre-select the pricelist when coming from the filtered index.
      @product_price = ProductPrice.new(pricelist_id: params[:pricelist_id])
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
      respond_to do |format|
        if @product_price.update(product_price_params)
          format.html { redirect_to [:backoffice, @product_price], notice: 'Product Price was successfully updated.' }
          format.json { head :ok }
        else
          render :edit
        end
      end
    end

    def bp_update
      @product_price = ProductPrice.find_by(product_id: params[:product_id], pricelist_id: params[:pricelist_id])
      @product_price = ProductPrice.new(product_id: params[:product_id], pricelist_id: params[:pricelist_id]) unless @product_price
      respond_to do |format|
        if @product_price.update(price_cents: params[:product][:temp_product_price])
          format.json { head :ok }
        else
          format.json { head :ok }
        end
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
