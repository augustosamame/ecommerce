require_dependency "ecommerce/application_controller"

module Ecommerce
  class CheckoutController < ApplicationController
    #skip_before_action :authenticate_user!, only: [:show]
    #before_action :set_checkout, only: [:show, :edit, :update, :destroy]
    before_action :create_order, only: [:pay_order_culqi_checkout]

    # GET /checkout
    def show
      @address = Address.new(user_id: current_user.id)
      @picked_address = Address.new(user_id: current_user.id)
      @checkout_addresses = Address.where(user_id: current_user.id)
      render "ecommerce/#{Ecommerce.ecommerce_layout}/checkout/show"
    end

    def create_order
      posted_address = params[:picked_shipping_address_id]
      last_user_address = Address.where(user_id: current_user.id).order(:id).last
      @order = Order.new( user_id: current_user.id,
                    amount_cents: params[:amount].to_i,
                    stage: "stage_new",
                    cart_id: params[:cart_id].to_i,
                    shipping_address_id: posted_address.blank? ? last_user_address.id : posted_address.to_i,
                    billing_address_id: nil,
                    payment_status: "paid",
                    status: "active"
                    )
      if @order.save
        clear_cart
      end
    end

    def clear_cart
      session[:cart_id] = nil
    end

    def pay_order_culqi_checkout
      Rails.logger.debug params
      card_token_created = Card.new.create_new_from_culqi(current_user, params[:culqi_token])
      payment_created = Payment.new.new_culqi_payment(current_user, card_token_created, params[:amount], "Order", @order.id, params[:payment_request_id]) if card_token_created
      if payment_created[0]
        #@payment_request = PaymentRequest.find(params[:payment_request_id])
        #if @payment_request
        #  PaymentRequest.transaction do
        #    @payment_request.order.update(status: "Paid")
        #    @payment_request.order.payment_requests.update_all(status: "Paid")
        #  end
        #end
        flash[:notice] = 'Su Orden fue Pagada Exitosamente'
        Rails.logger.info payment_created[0]
        flash.keep(:notice)
        #render js: "window.location = '#{order_path(payment_request.order_id)}'"
        redirect_to root_path, notice: 'Pago exitoso'
      else
        flash[:error] = payment_created[1] || 'Error al Realizar el Pago'
        Rollbar.error(payment_created[1])
        Rails.logger.error payment_created[1]
        flash.keep(:error)
        #render js: "window.location = '#{order_path(payment_request.order_id)}'"
        redirect_to "ecommerce/#{Ecommerce.ecommerce_layout}/checkout/show", error: 'Error al realizar el Pago'
      end
    end

    private

      # Only allow a trusted parameter "white list" through.
      def cart_params
        params.require(:checkout).permit(:user_id)
      end
  end
end
