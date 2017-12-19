require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::ProductsController < ApplicationController
    before_action :set_backoffice_product, only: [:show, :edit, :update, :destroy]

    # GET /backoffice/products
    def index
      @backoffice_products = Backoffice::Product.all
    end

    # GET /backoffice/products/1
    def show
    end

    # GET /backoffice/products/new
    def new
      @backoffice_product = Backoffice::Product.new
    end

    # GET /backoffice/products/1/edit
    def edit
    end

    # POST /backoffice/products
    def create
      @backoffice_product = Backoffice::Product.new(backoffice_product_params)

      if @backoffice_product.save
        redirect_to @backoffice_product, notice: 'Product was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/products/1
    def update
      if @backoffice_product.update(backoffice_product_params)
        redirect_to @backoffice_product, notice: 'Product was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/products/1
    def destroy
      @backoffice_product.destroy
      redirect_to backoffice_products_url, notice: 'Product was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_product
        @backoffice_product = Backoffice::Product.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_product_params
        params.require(:backoffice_product).permit(:name, :description, :image)
      end
  end
end
