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
      @error_alert = params[:error]
      @payment_credit_card_visanet = PaymentMethod.is_active.find_by(name: "Card", processor: "Visanet")
      @payment_credit_card_culqi = PaymentMethod.is_active.find_by(name: "Card", processor: "Culqi")
      render "ecommerce/#{Ecommerce.ecommerce_layout}/order/show"
    end

    def culqi_webhook
      puts 'CULQI_WEBHOOK EVENT RECEIVED'
      puts params
      Rails.logger.debug params
      Rails.logger.debug 'CULQI_WEBHOOK EVENT RECEIVED'
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

        cart = Cart.find(params[:cart_id])
        cart_subtotal = cart.cart_items.includes(:product).sum(&:line_total)
        case found_coupon.coupon_type
        when "percentage_discount"
          discount = cart_subtotal.to_f * (found_coupon.dicount_percentage.to_f / 100)
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
              discount += cart_line.line_total.to_f * (found_coupon.dicount_percentage.to_f / 100)
            end
            response = {
                       :result => "ok",
                       :discount => - discount,
                       :free_shipping => found_coupon.free_shipping?
                       }
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
