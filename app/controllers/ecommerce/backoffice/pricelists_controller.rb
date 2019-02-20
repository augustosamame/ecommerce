require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::PricelistsController < Backoffice::BaseController
    before_action :set_pricelist, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::Pricelist"

    # GET /pricelists
    def index
      @pricelists = Pricelist.all
    end

    # GET /pricelists/1
    def show
      @backoffice_products = @pricelist.product_prices
    end

    # GET /pricelists/new
    def new
      @pricelist = Pricelist.new
      @pricelist.status = "active"
    end

    # GET /pricelists/1/edit
    def edit
    end

    # POST /pricelists
    def create
      @pricelist = Pricelist.new(pricelist_params)

      if @pricelist.save
        redirect_to [:backoffice, @pricelist], notice: 'Pricelist was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /pricelists/1
    def update
      if @pricelist.update(pricelist_params)
        redirect_to [:backoffice, @pricelist], notice: 'Pricelist was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /pricelists/1
    def destroy
      @pricelist.destroy
      redirect_to backoffice_pricelists_url, notice: 'Pricelist was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_pricelist
        @pricelist = Pricelist.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def pricelist_params
        params.require(:pricelist).permit(:name, :status)
      end
  end
end
