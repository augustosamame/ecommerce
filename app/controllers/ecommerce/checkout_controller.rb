require_dependency "ecommerce/application_controller"

module Ecommerce
  class CheckoutController < ApplicationController
    #skip_before_action :authenticate_user!, only: [:show]
    #before_action :set_checkout, only: [:show, :edit, :update, :destroy]
    before_action :create_order, only: [:pay_order_culqi_checkout]

    # GET /checkout
    def show
      render "ecommerce/#{Ecommerce.ecommerce_layout}/checkout/show"
    end

    def create_order
      @order = Order.create( user_id: current_user.id,
                    amount_cents: params[:amount].to_i,
                    stage: "stage_new",
                    cart_id: params[:cart_id].to_i,
                    shipping_address_id: nil,
                    billing_address_id: nil,
                    payment_status: "unpaid",
                    status: "active"
                    )
    end

    def pay_order_culqi_checkout
      Rails.logger.debug params
      card_token_created = Card.new.create_new_from_culqi(current_user, params[:culqi_token])
      payment_created = Payment.new.new_culqi_payment(current_user, card_token_created, params[:amount], "Order", @order.id, params[:payment_request_id]) if card_token_created
      if payment_created[0]
        @payment_request = PaymentRequest.find(params[:payment_request_id])
        if @payment_request
          PaymentRequest.transaction do
            @payment_request.order.update(status: "Paid")
            @payment_request.order.payment_requests.update_all(status: "Paid")
          end
        end
        flash[:notice] = 'Su Orden fue Pagada Exitosamente'
        Rails.logger.info payment_created[0]
        flash.keep(:notice)
        render js: "window.location = '#{order_path(payment_request.order_id)}'"
        #redirect_to edit_user_registration_path, notice: 'Recarga exitosa'
      else
        flash[:error] = payment_created[1] || 'Error al Realizar el Pago'
        Rollbar.error(payment_created[1])
        Rails.logger.error payment_created[1]
        flash.keep(:error)
        render js: "window.location = '#{order_path(payment_request.order_id)}'"
        #redirect_to edit_user_registration_path, error: 'Error al realizar la recarga'
      end
    end

    private

      # Only allow a trusted parameter "white list" through.
      def cart_params
        params.require(:checkout).permit(:user_id)
      end
  end
end
