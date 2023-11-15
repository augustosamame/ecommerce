require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::BrandsController < Backoffice::BaseController
    before_action :set_backoffice_brand, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::Brand"

    # GET /backoffice/brands
    def index
      @backoffice_brands = Brand.all
    end

    # GET /backoffice/brands/1
    def show
    end

    # GET /backoffice/brands/new
    def new
      @backoffice_brand = Brand.new
    end

    # GET /backoffice/brands/1/edit
    def edit
    end

    # POST /backoffice/brands
    def create
      @backoffice_brand = Brand.new(backoffice_brand_params)

      if @backoffice_brand.save
        redirect_to backoffice_brand_path(@backoffice_brand), notice: 'Brand was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/brands/1
    def update
      if @backoffice_brand.update(backoffice_brand_params)
        redirect_to backoffice_brand_path(@backoffice_brand), notice: 'Brand was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/brands/1
    def destroy
      @backoffice_brand.destroy
      redirect_to backoffice_brands_url, notice: 'Brand was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_brand
        @backoffice_brand = Brand.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_brand_params
        params.require(:brand).permit(:name, :logo, :logo_cache, :featured, :featured_link)
      end
  end
end
