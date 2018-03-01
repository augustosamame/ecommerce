require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::OrdersController < Backoffice::BaseController
    before_action :set_backoffice_order, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::Order"

    # GET /backoffice/orders
    def index
      if params[:stage]
        @backoffice_orders = Order.where(stage: params[:stage])
      else
        @backoffice_orders = Order.all
      end
    end

    # GET /backoffice/orders/1
    def show
    end

    # GET /backoffice/orders/new
    def new
      @backoffice_order = Order.new
    end

    # GET /backoffice/orders/1/edit
    def edit
    end

    # POST /backoffice/orders
    def create
      @backoffice_order = Order.new(backoffice_order_params)

      if @backoffice_order.save
        redirect_to backoffice_order_path(@backoffice_order), notice: 'Order was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/orders/1
    def update
      if @backoffice_order.update(backoffice_order_params)
        redirect_to backoffice_order_path(@backoffice_order), notice: 'Order was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/orders/1
    def destroy
      @backoffice_order.destroy
      redirect_to backoffice_orders_url, notice: 'Order was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_order
        @backoffice_order = Order.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_order_params
        params.require(:order).permit(:user_id, :amount_cents, :stage, :shipping_address_id, :billing_address_id, :coupon_id, :payment_status, :status)
      end
  end
end
