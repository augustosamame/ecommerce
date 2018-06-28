require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::ProductsController < Backoffice::BaseController
    before_action :set_backoffice_product, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::Product" #we have to do this because controller and model do not have the same namespace

    # GET /backoffice/products
    def index
      @backoffice_products = Product.all.order(id: :desc)
    end

    # GET /backoffice/products/1
    def show
    end

    # GET /backoffice/products/new
    def new
      @backoffice_product = Product.new
      @backoffice_product.stockable = true
      #@backoffice_product.product_skus.build
    end

    # GET /backoffice/products/1/edit
    def edit
    end

    # POST /backoffice/products
    def create
      puts params
      @backoffice_product = Product.new(backoffice_product_params)
      @backoffice_product.category_list.add(backoffice_product_params[:category_id])
      @backoffice_product.permalink = @backoffice_product.name
      if @backoffice_product.save
        redirect_to backoffice_product_path(@backoffice_product), notice: 'Product was successfully created.'
      else
        Rails.logger.error @backoffice_product.errors
        render :new
      end
    end

    # PATCH/PUT /backoffice/products/1
    def update
      if @backoffice_product.update(backoffice_product_params)
        @backoffice_product.category_list = backoffice_product_params[:category_id]
        @backoffice_product.save
        redirect_to backoffice_product_path(@backoffice_product), notice: 'Product was successfully updated.'
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
        @backoffice_product = Product.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_product_params
        params.require(:product).permit(:brand_id, :supplier_id, :name, :description, :description2, :price_cents, :discounted_price_cents, :stockable, :home_featured, :image, :image_cache, category_id: [], category_list: [], :product_skus_attributes => [:id, :sku, :price_cents, :status, :_destroy])
      end
  end
end
