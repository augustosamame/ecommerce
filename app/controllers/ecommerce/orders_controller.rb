require_dependency "ecommerce/application_controller"

module Ecommerce
  class OrdersController < ApplicationController

    skip_before_action :verify_authenticity_token, only: [:culqi_webhook]
    skip_before_action :authenticate_user!, only: [:culqi_webhook]

    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}"
    before_action :set_order, only: [:show]

    authorize_resource

    def index
      @orders = Order.where(user_id: current_user.id).order(id: :desc)
      render "ecommerce/#{Ecommerce.ecommerce_layout}/order/index"
    end

    def show
      @error_alert = params[:error]
      @payment_credit_card_visanet = PaymentMethod.is_active.find_by(name: "Card", processor: "Visanet")
      @payment_credit_card_culqi = PaymentMethod.is_active.find_by(name: "Card", processor: "Culqi")

      @current_user_first_name = current_user.first_name
      @current_user_last_name = current_user.last_name
      @current_user_email = current_user.email
      @current_user_phone = "+51#{current_user.username}".split(':')[0].gsub(/[^\d]/, '')
      
      render "ecommerce/#{Ecommerce.ecommerce_layout}/order/show"
    end

    def culqi_webhook
      if params[:object] == "event" && params[:type] == "order.status.changed"
        Rollbar.info("Webhook Received",
          :request_data => params
        )
        culqi_data = JSON.parse(params[:data])
        if culqi_data["state"] == 'paid'
          found_culqi_payment = Payment.find_by(processor_transaction_id: culqi_data["id"])
          if found_culqi_payment
            Payment.create(
              user_id: found_culqi_payment.user_id,
              order_id: found_culqi_payment.order_id,
              payment_method_id: found_culqi_payment.payment_method_id,
              processor_transaction_id: found_culqi_payment.processor_transaction_id,
              amount_cents: culqi_data["amount"].to_i,
              comment: params[:id],
              date: Time.now,
              status: 'active'
            )
          end
        end
      end
      head :ok
    end

    def calculate_coupon
      puts params
      found_coupon = Coupon.find_by(coupon_code: params[:coupon_code])
      if found_coupon

        #check max_uses_per_user
        if found_coupon.max_uses_per_user && found_coupon.max_uses_per_user > 0
          times_used_by_user = Order.where(coupon_id: found_coupon.id, user_id: current_user.id, status: "active").count
          if times_used_by_user >= found_coupon.max_uses_per_user
            response = {
                        :result => "error",
                        :error_message => I18n.t('controllers.orders.calculate_coupon.max_times_per_user_exceeded')
                       }
            respond_to do |format|
              format.json { render json: response.to_json and return}
            end
          end
        end

        #check max_uses_total
        if found_coupon.max_uses && found_coupon.max_uses > 0
          times_used = Order.where(coupon_id: found_coupon.id, status: "active").count
          if times_used >= found_coupon.max_uses
            response = {
                        :result => "error",
                        :error_message => I18n.t('controllers.orders.calculate_coupon.max_times_exceeded')
                       }
            respond_to do |format|
              format.json { render json: response.to_json and return}
            end
          end
        end

        #check expiration
        if found_coupon.end_date && Date.today > found_coupon.end_date
          response = {
                      :result => "error",
                      :error_message => I18n.t('controllers.orders.calculate_coupon.coupon_expired')
                     }
          respond_to do |format|
            format.json { render json: response.to_json and return}
          end
        end

        cart = Cart.find(params[:cart_id])
        cart_subtotal = 0
        cart.cart_items.includes(:product).each do |cart_item|
          cart_subtotal += cart_item.line_total(current_user)
        end

        if found_coupon.minimum_quantity_applies
          product_name = Ecommerce::Product.find(found_coupon.minimum_quantity_product).try(:name)
          case found_coupon.coupon_type
          when "percentage_discount"
            applicable_cart_items = cart.cart_items.includes(:product).where(product_id: found_coupon.minimum_quantity_product)
            discount = 0
            total_quantity = 0
            applicable_cart_items.each do |cart_item|
              line_discount = cart_item.line_total(current_user).to_f * (found_coupon.discount_percentage_decimal.to_f / 100)
              discount += line_discount
              total_quantity += cart_item.quantity
            end
            if total_quantity >= found_coupon.minimum_quantity
              response = {
                          :result => "ok",
                          :discount => - discount,
                          :free_shipping => found_coupon.free_shipping?
                        }
            else
              response = {
                          :result => "error",
                          :error_message => I18n.t('controllers.orders.calculate_coupon.not_enough_quantity', product_name: product_name, minimum_quantity: found_coupon.minimum_quantity)
                        }
            end
          when "fixed_discount_without_threshold"
            applicable_cart_items = cart.cart_items.includes(:product).where(product_id: found_coupon.minimum_quantity_product)
            total_quantity = 0
            applicable_cart_items.each do |cart_item|
              total_quantity += cart_item.quantity
            end
            if total_quantity >= found_coupon.minimum_quantity
              discount = found_coupon.discount_fixed
              response = {
                          :result => "ok",
                          :discount => - discount,
                          :free_shipping => found_coupon.free_shipping?
                        }
            else
              discount = 0
              response = {
                          :result => "error",
                          :error_message => I18n.t('controllers.orders.calculate_coupon.not_enough_quantity', product_name: product_name, minimum_quantity: found_coupon.minimum_quantity)
                        }
            end
          end
        else
          if found_coupon.combo_applies
            combo_product_ids = found_coupon.combo_products[0].split(",").map(&:to_i)            
            combo_products = Ecommerce::Product.where(id: combo_product_ids)
            qualifying_unique_cart_items = cart.cart_items.includes(:product).where(product_id: combo_product_ids).select(:product_id).distinct
            if qualifying_unique_cart_items.length == combo_product_ids.length
              found_number_of_combos = qualifying_unique_cart_items.min(:quantity) #this is the number of combos that can be applied (at least x quantity of each product in the combo)
            else
              found_number_of_combos = 0 #no complete combos were found
            end
            case found_coupon.coupon_type
            when "percentage_discount"
              discount_per_combo = 0
              combo_products.each do |combo_product|
                product_price = combo_product.current_price(current_user)
                discount_per_combo += (product_price * (found_coupon.discount_percentage_decimal.to_f / 100))
              end
              discount = discount_per_combo * found_number_of_combos
              if discount == 0
                product_names = combo_products.map(&:name).join(", ")
                response = {
                            :result => "error",
                            :error_message => I18n.t('controllers.orders.calculate_coupon.no_combo_qualifying_products', product_names: product_names)
                           }
              else
                response = {
                            :result => "ok",
                            :discount => - discount,
                            :free_shipping => found_coupon.free_shipping?
                           }
              end
            when "fixed_discount_without_threshold"
              discount_per_combo = found_coupon.discount_fixed
            end
          
          else

            case found_coupon.coupon_type
            when "percentage_discount"
              discount = cart_subtotal.to_f * (found_coupon.discount_percentage_decimal.to_f / 100)
              response = {
                          :result => "ok",
                          :discount => - discount,
                          :free_shipping => found_coupon.free_shipping?
                        }
            when "fixed_discount_with_threshold"
              if cart_subtotal.to_f < found_coupon.discount_threshold
                response = {
                            :result => "error",
                            :error_message => I18n.t('controllers.orders.calculate_coupon.order_under_coupon_threshold')
                          }
              else
                discount = found_coupon.discount_fixed || 0
                response = {
                            :result => "ok",
                            :discount => - discount,
                            :free_shipping => found_coupon.free_shipping?
                          }
              end
            when "fixed_discount_without_threshold"
              discount = found_coupon.discount_fixed || 0
              response = {
                          :result => "ok",
                          :discount => - discount,
                          :free_shipping => found_coupon.free_shipping?
                        }
            when "percentage_discount_per_product"

              qualifying_products = found_coupon.products.pluck(:id)
              qualifying_products_in_cart = cart.cart_items.where(product_id: qualifying_products)
              if qualifying_products_in_cart.empty?
                response = {
                            :result => "error",
                            :error_message => I18n.t('controllers.orders.calculate_coupon.no_qualifying_products')
                          }
              else
                discount = 0
                qualifying_products_in_cart.each do |cart_line|
                  discount += cart_line.line_total(current_user).to_f * (found_coupon.discount_percentage_decimal.to_f / 100)
                end
                response = {
                          :result => "ok",
                          :discount => - discount,
                          :free_shipping => found_coupon.free_shipping?
                          }
              end
            end
          end
        end
      else
        response = {
                    :result => "error",
                    :error_message => I18n.t('controllers.orders.calculate_coupon.coupon_not_found')
                   }
      end

      respond_to do |format|
        format.json { render json: response.to_json }
      end
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
