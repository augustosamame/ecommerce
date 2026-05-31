require_dependency "ecommerce/application_controller"

module Ecommerce
  # Singleton-style controller — the model has at most one row, so all
  # actions operate on Ecommerce::FreeProduct.current. No new/create/destroy.
  class Backoffice::FreeProductsController < Backoffice::BaseController
    before_action :set_free_product
    authorize_resource :class => "Ecommerce::FreeProduct"

    # GET /backoffice/free_product
    def show
      redirect_to edit_backoffice_free_product_path
    end

    # GET /backoffice/free_product/edit
    def edit
    end

    # PATCH/PUT /backoffice/free_product
    def update
      if @free_product.update(free_product_params)
        redirect_to edit_backoffice_free_product_path, notice: 'Free Product settings updated.'
      else
        render :edit
      end
    end

    private

    def set_free_product
      @free_product = FreeProduct.current
    end

    def free_product_params
      params.require(:free_product).permit(:web_active, :app_active, :product_id)
    end
  end
end
