require_dependency "ecommerce/application_controller"

module Ecommerce
  class CheckoutController < ApplicationController
    #skip_before_action :authenticate_user!, only: [:show]
    #before_action :set_checkout, only: [:show, :edit, :update, :destroy]
    before_action :find_or_create_order, only: [:pay_order_culqi_checkout, :pay_order_bank, :pay_order_manual]

    # GET /checkout
    def show
      @address = Address.new(user_id: current_user.id)
      @picked_address = Address.new(user_id: current_user.id)
      @checkout_addresses = Address.where(user_id: current_user.id)
      @districts = ['San Isidro', 'Miraflores', 'Barranco', 'Santiago de Surco', 'La Molina','Chorrillos','San Borja','San Luis','Surquillo','San Miguel','Pueblo Libre','La Victoria','Magdalena','Jesus María','Lince','Breña'].sort
      @cart_subtotal = @cart.cart_items.includes(:product).sum(&:line_total)
      #active payment methods in view
      @payment_bank_deposit = PaymentMethod.is_active.find_by(name: "Bank Deposit")
      @payment_manual = PaymentMethod.is_active.find_by(name: "Manual")
      @payment_credit_card_visanet = PaymentMethod.is_active.find_by(name: "Card", processor: "Visanet")
      @payment_credit_card_culqi = PaymentMethod.is_active.find_by(name: "Card", processor: "Culqi")

      @dni_required = (@cart_subtotal.to_f >= 210)

      @coupons_active = Ecommerce::allow_coupons

      @exchange_rate = Ecommerce::Control.get_control_value("exchange_rate") || 3.3

      info_factura_vat = !Ecommerce::DataBizInvoice.find_by(user_id: current_user.id).try(:vat).blank?
      @info_factura_available = false
      if info_factura_vat
        @info_factura = Ecommerce::DataBizInvoice.find_by(user_id: current_user.id)
        @info_factura_available = true
        @factura_vat = @info_factura.vat
        @factura_razon_social = @info_factura.razon_social
        @factura_address = @info_factura.address
        @factura_city = @info_factura.city
      end

      render "ecommerce/#{Ecommerce.ecommerce_layout}/checkout/show"
    end

    def find_or_create_order
      if params[:order_id]
        @order = Order.find(params[:order_id])
      else
        posted_address = params[:picked_shipping_address_id]
        last_user_address = Address.where(user_id: current_user.id).order(:id).last
        used_coupon = Coupon.find_by(coupon_code: params[:applied_coupon])
        ActiveRecord::Base.transaction do
          @order = Order.new( user_id: current_user.id,
                        amount: Money.new(params[:amount].to_i, session[:currency]),
                        shipping_amount: Money.new((params[:shipping_amount].to_i), session[:currency]),
                        stage: "stage_new",
                        cart_id: params[:cart_id].to_i,
                        shipping_address_id: posted_address.blank? ? last_user_address.id : posted_address.to_i,
                        billing_address_id: posted_address.blank? ? last_user_address.id : posted_address.to_i,
                        payment_status: "unpaid",
                        efact_type: params[:want_factura] == "true" ? "factura" : "boleta",
                        required_doc: params[:required_doc],
                        coupon_id: used_coupon.try(:id),
                        discount_amount: Money.new((params[:discount_amount].to_i), session[:currency]),
                        status: "active"
                        )
          if used_coupon
            current_uses = used_coupon.current_uses || 0
            used_coupon.update(current_uses: current_uses + 1)
          end
          if @order.save
            @cart_items = CartItem.where(cart_id: params[:cart_id].to_i)
            @cart_items.each do |item|
              OrderItem.create!(
                order_id: @order.id,
                product_id: item.product_id,
                price: item.product.current_price,
                #price_cents: (item.product.current_price.to_f * 100).to_i,
                quantity: item.quantity,
                status: "active"
              )
            end
            close_cart_and_create_new
          end
        end
      end
    end

    def close_cart_and_create_new
      @cart.update(status: "closed")
      @cart = Cart.create(user_id: current_user.id, status: "active")
      session[:cart_id] = @cart.id
    end

    def pay_order_culqi_checkout
      Rails.logger.debug params
      card_token_created = Card.new.create_new_from_culqi(current_user, params[:culqi_token])
      payment_created = Payment.new.new_culqi_payment(current_user, card_token_created, params[:culqi_payment_amount], params[:currency], "Order", @order.id, params[:payment_request_id]) if card_token_created
      if payment_created[0]
        flash[:notice] = t('.your_order_was_successfully_placed')
        Rails.logger.info payment_created[0]
        flash.keep(:notice)
        render js: "window.location = '#{root_path}'"
        #redirect_to root_path, notice: 'Pago exitoso'
      else
        flash[:error] = payment_created[1] || t('.error_when_processing_payment')
        Rollbar.error(payment_created[1])
        Rails.logger.error payment_created[1]
        flash.keep(:error)
        render js: "window.location = '#{order_path(@order.id)}'"
        #redirect_to "ecommerce/#{Ecommerce.ecommerce_layout}/checkout/show", error: 'Error al realizar el Pago'
      end
    end

    def pay_order_bank
      Rails.logger.debug params
      flash[:notice] = t('.your_order_was_successfully_placed')
      flash.keep(:notice)
      render js: "window.location = '#{order_path(@order.id)}'"
    end

    def pay_order_manual
      Rails.logger.debug params
      flash[:notice] = t('.your_order_was_successfully_placed')
      flash.keep(:notice)
      render js: "window.location = '#{order_path(@order.id)}'"
    end

    private

      # Only allow a trusted parameter "white list" through.
      def cart_params
        params.require(:checkout).permit(:user_id)
      end
  end
end
