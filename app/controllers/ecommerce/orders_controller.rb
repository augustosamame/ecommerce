require_dependency "ecommerce/application_controller"

module Ecommerce
  class OrdersController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}"
    before_action :set_order, only: [:show]

    authorize_resource

    def index
      @orders = Order.where(user_id: current_user.id).order(id: :desc)
      render "ecommerce/#{Ecommerce.ecommerce_layout}/order/index"
    end

    def show
      render "ecommerce/#{Ecommerce.ecommerce_layout}/order/show"
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_order
        @order = Order.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def order_params
        params.require(:order).permit(:id)
      end

  end
end
