require_dependency "ecommerce/application_controller"

module Ecommerce
  class CheckoutController < ApplicationController
    #skip_before_action :authenticate_user!, only: [:show]
    #before_action :set_checkout, only: [:show, :edit, :update, :destroy]
    before_action :find_or_create_order, only: [:pay_order_culqi_checkout, :pay_order_pagoefectivo_checkout, :pay_order_bank, :pay_order_manual]
    before_action :consolidate_cart, only: [:show]
    before_action :check_stock_cart, only: [:show]

    def consolidate_cart
      already_added = Array.new
      @cart.cart_items.each do |cart_item|
        unless already_added.include? cart_item.id
          found_same_product = @cart.cart_items.where(product_id: cart_item.product_id).where.not(id: cart_item.id).first
          if found_same_product
            new_quantity = found_same_product.quantity + cart_item.quantity
            cart_item.update(quantity: new_quantity)
            found_same_product.update(quantity: 0)
            already_added << found_same_product.id
          end
        end
      end
      # destroy all zero rows
      non_cached_cart = Ecommerce::Cart.find(@cart.id)
      non_cached_cart.cart_items.each do |cart_item|
        cart_item.destroy if cart_item.quantity < 1
      end
      set_cart
    end

    def check_stock_cart
      @not_in_stock_array = Array.new
      @not_in_stock_alert_en = ''
      @not_in_stock_alert_es = ''
      @cart.cart_items.each do |cart_item|
        if cart_item.product.inactive? || (cart_item.quantity > cart_item.product.total_quantity)
          adjusted_quantity = cart_item.product.inactive? ? 0 : cart_item.product.total_quantity
          @not_in_stock_array << { inactive: cart_item.product.inactive?, new_quantity: adjusted_quantity }
          if cart_item.product.inactive? || cart_item.product.total_quantity == 0
            @not_in_stock_alert_en += "#{cart_item.product.name} is no longer available. If has been removed from your cart. "
            @not_in_stock_alert_es += "#{cart_item.product.name} ya no se encuentra disponible. Lo hemos eliminado de su carrito de compras. "
            cart_item.destroy
          else
            @not_in_stock_alert_en += "#{cart_item.product.name} only has Qty: #{cart_item.product.total_quantity} available. We have adjusted the quantity in your cart. "
            @not_in_stock_alert_es += "#{cart_item.product.name} solo tiene Cant: #{cart_item.product.total_quantity} disponible. Hemos ajustado la cantidad en su carrito. "
            cart_item.update(quantity: adjusted_quantity)
          end
        end
      end

      set_cart #in order to refresh cart after modifying cart_items

    end

    def check_stock_cart_js_from_checkout
      not_in_stock = false
      @cart.cart_items.each do |cart_item|
        if cart_item.product.inactive? || (cart_item.quantity > cart_item.product.total_quantity)
          not_in_stock = true
        end
      end
      respond_to do |format|
        format.json {
          render json: { in_stock: !not_in_stock }.to_json and return
        }
      end
    end

    # GET /checkout
    def show
      @address = Address.new(user_id: current_user.id)
      @picked_address = Address.new(user_id: current_user.id)
      @checkout_addresses = Address.where(user_id: current_user.id)
      @districts = ['San Isidro', 'Miraflores', 'Barranco', 'Santiago de Surco', 'La Molina','Chorrillos','San Borja','San Luis','Surquillo','San Miguel','Pueblo Libre','La Victoria','Magdalena','Jesus María','Lince'].sort
      @cart_subtotal = 0
      @cart.cart_items.includes(:product).each do |cart_item|
        @cart_subtotal += cart_item.line_total(current_user)
      end
      #active payment methods in view
      @payment_bank_deposit = PaymentMethod.is_active.find_by(name: "Bank Deposit")
      @payment_manual = PaymentMethod.is_active.find_by(name: "Manual")
      @payment_credit_card_visanet = PaymentMethod.is_active.find_by(name: "Card", processor: "Visanet")
      @payment_credit_card_culqi = PaymentMethod.is_active.find_by(name: "Card", processor: "Culqi")
      @current_doc_id = current_user.doc_id
      @dni_required = (@cart_subtotal.to_f >= 210)
      #@dni_required = (@cart_subtotal.to_f >= 10)

      @current_user_first_name = current_user.first_name
      @current_user_last_name = current_user.last_name
      @current_user_email = current_user.email
      @current_user_phone = "+51#{current_user.username}".split(':')[0].gsub(/[^\d]/, '')

      @coupons_active = Ecommerce::allow_coupons

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
      if params[:cart_id]
        cart_still_active = Cart.find_by(id: params[:cart_id].to_i)
        unless cart_still_active
          flash[:error] = t('.error_cart_already_placed')
          flash.keep(:error)
          render js: "window.location = '#{orders_path}'"
        end
      end
      order_with_cart_exists = Order.find_by(cart_id: params[:cart_id].to_i)
      @order = order_with_cart_exists
      unless @order
        if params[:order_id]
          @order = Order.find(params[:order_id])
        else
          posted_address = params[:picked_shipping_address_id]
          last_user_address = Address.where(user_id: current_user.id).order(:id).last
          used_coupon = Coupon.find_by(coupon_code: params[:applied_coupon])
          points_redeemed_amount = params[:points_redeemed_amount].to_i
          ActiveRecord::Base.transaction do
            @order = Order.new( user_id: current_user.id,
                          amount: Money.new((params[:amount].to_i + points_redeemed_amount), session[:currency]),
                          shipping_amount: Money.new((params[:shipping_amount].to_i), session[:currency]),
                          stage: "stage_new",
                          cart_id: params[:cart_id].to_i,
                          shipping_address_id: posted_address.blank? ? last_user_address.id : posted_address.to_i,
                          billing_address_id: posted_address.blank? ? last_user_address.id : posted_address.to_i,
                          payment_status: "unpaid",
                          efact_type: params[:want_factura] == "true" ? "factura" : "boleta",
                          required_doc: params[:required_doc],
                          delivery_comments: params[:delivery_instructions].try(:strip),
                          coupon_id: used_coupon.try(:id),
                          discount_amount: Money.new((params[:discount_amount].to_i), session[:currency]),
                          points_redeemed_amount: points_redeemed_amount,
                          status: "active",
                          process_comments: params[:pagoefectivo_payment_code].blank? ? "" : "Pagoefectivo CIP #{params[:pagoefectivo_payment_code]}"
                          )
            if used_coupon
              current_uses = used_coupon.current_uses || 0
              used_coupon.update(current_uses: current_uses + 1)
            end
            if @order.save
              ActiveRecord::Base.transaction do
                current_user.update(doc_id: @order.required_doc) unless @order.required_doc.blank?
                unless @order.points_redeemed_amount.blank?
                  current_user.update(points: (current_user.points - @order.points_redeemed_amount))
                  PointsTransaction.create(user_id: current_user.id, points: -@order.points_redeemed_amount, tx_type: 'redemption', tx_id: @order.id)
                end
                @cart_items = CartItem.where(cart_id: params[:cart_id].to_i)
                @cart_items.each do |item|
                  OrderItem.create!(
                    order_id: @order.id,
                    product_id: item.product_id,
                    price: item.product.current_price(current_user),
                    quantity: item.quantity,
                    status: "active"
                  )
                end
                close_cart_and_create_new
              end
            end
          end
        end
      end
    end

    def close_cart_and_create_new
      @cart.update(status: "closed")
      @cart = Cart.create(user_id: current_user.id, status: "active", abandoned_email_sent: false)
      session[:cart_id] = @cart.id
    end

    def pay_order_culqi_checkout
      Rails.logger.debug params
      points_payment_method = PaymentMethod.find_by(name: "Points")
      card_token_created = Card.new.create_new_from_culqi(current_user, params[:culqi_token])
      if card_token_created

        #points payment
        Payment.create(
          user_id: current_user.id,
          order_id: @order.id,
          payment_method_id: points_payment_method.id,
          payment_request_id: params[:payment_request_id],
          amount_cents: params[:points_redeemed_amount],
          date: Time.now, status: "active"
        ) unless params[:points_redeemed_amount].blank?

        #card payment
        payment_created = Payment.new.new_culqi_payment(
          current_user,
          card_token_created,
          params[:culqi_payment_amount],
          params[:currency],
          "Order",
          @order.id,
          params[:payment_request_id]
        )

      end
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
        render js: "window.location = '#{order_path(@order.id, :error => t('.error_when_processing_payment'))}'"
        #redirect_to "ecommerce/#{Ecommerce.ecommerce_layout}/checkout/show", error: 'Error al realizar el Pago'
      end
    end

    def pay_order_pagoefectivo_checkout
      Rails.logger.debug params
      payment_created = Payment.new.new_pagoefectrivo_payment(current_user, params[:culqi_order_id], params[:culqi_payment_amount], params[:currency], "Order", @order.id, params[:payment_request_id])
      flash[:notice] = t('.your_order_was_successfully_placed_pagoefectivo')
      flash.keep(:notice)
      render js: "window.location = '#{order_path(@order.id, :notice => t('.your_order_was_successfully_placed'))}'"
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
