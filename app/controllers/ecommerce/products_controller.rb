require_dependency "ecommerce/application_controller"

module Ecommerce
  class ProductsController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}"
    skip_before_action :authenticate_user!
    before_action :set_product, only: [:show]

    def index

      @products = Product.all

    end

  end
end
