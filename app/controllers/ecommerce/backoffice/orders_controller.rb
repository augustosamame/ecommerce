require_dependency "ecommerce/application_controller"
require 'net/http'
require 'uri'
require 'json'

module Ecommerce
  class Backoffice::OrdersController < Backoffice::BaseController
    skip_before_action :authorize_role, only: [:create_culqi_order]
    before_action :set_backoffice_order, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::Order", except: [:show]
    skip_authorization_check only: [:show]
    before_action :authorize_order_access, only: [:show]

    def einvoice
      @backoffice_order = Order.find(params[:format])
      @order_details = Order.find(@backoffice_order.id).order_items.includes(:product)
      #begin
        @einvoice = JSON.parse(@backoffice_order.generate_einvoice)
      #rescue Net::OpenTimeout
      #  retry
      #end
      if @einvoice["response_text"] == "OK"
        @epdf = @einvoice["response_url"]
      else
        @einvoice_error_message = @einvoice["response_text"] || "#{@einvoice["status"]} : #{@einvoice["error"]}"
      end
      render :action => "show"
    end

    # GET /backoffice/orders
    def index
      if params[:stage]
        @backoffice_orders = Order.where(stage: params[:stage]).order(id: :desc).page(params[:page])
      else
        @backoffice_orders = Order.all.order(id: :desc).page(params[:page])
      end
      @page_param = params[:page]
    end

    # GET /backoffice/orders/1
    def show
      @order_details = Order.find(@backoffice_order.id).order_items.includes(:product)
      @payments = Payment.where(order_id: @backoffice_order.id).order(id: :desc)
      @epdf = @backoffice_order.efact_invoice_url
      if @backoffice_order.efact_response_text == "OK"
        @erefund_pdf = @backoffice_order.efact_refund_url
        @evoid_string = @backoffice_order.efact_void_url
      else
        @einvoice_error_message = @backoffice_order.efact_response_text
        @einvoice_sent_text = @backoffice_order.efact_sent_text
      end
      @backoffice_addresses = Address.where(id: @backoffice_order.shipping_address_id).or(Address.where(id: @backoffice_order.billing_address_id))
    end

    # GET /backoffice/orders/new
    def new
      @backoffice_order = Order.new(stage: "stage_new", payment_status: "unpaid", status: "active")
    end

    # GET /backoffice/orders/1/edit
    def edit
    end

    def create_culqi_order
      Rails.logger.info("Creating Culqi Order")
      data_to_send = {
        title: I18n.t('ecommerce.processor.culqi.payment_popup_title', site_name: Ecommerce.site_name),
        amount: params[:amount],
        currency_code: params[:currency_code],
        description: I18n.t('ecommerce.processor.culqi.order_label') + ": #{params[:cart_id]}",
        order_number: "#{params[:cart_id]}-cart-#{SecureRandom.random_number(10000)}",
        expiration_date: Time.now.to_i + (72 * 60 * 60),
        confirm: false,
        client_details: {
          first_name: params[:client_details][:first_name],
          last_name: params[:client_details][:last_name],
          email: params[:client_details][:email],
          phone_number: params[:client_details][:phone_number]
        }
      }

      url = URI('https://api.culqi.com/v2/orders')
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = 'application/json'
      request["Accept"] = 'application/json'
      request["Authorization"] = "Bearer #{Culqi.secret_key}"
      Rails.logger.info("Culqi Order Secret Key: #{Culqi.secret_key}")
      Rails.logger.info("Culqi Order URL: #{url.inspect}")
      Rails.logger.info("Culqi Order Data: #{data_to_send.inspect}")
      request.body = data_to_send.to_json

      response = http.request(request)
      Rails.logger.info("Culqi Order Response: #{response.body}")
      render json: JSON.parse(response.body)
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    # POST /backoffice/orders
    def create
      @backoffice_order = Order.new(backoffice_order_params)
      @backoffice_order.amount_cents = @backoffice_order.amount_cents * 100

      @cart = Cart.create(user_id: backoffice_order_params["user_id"], status: "active")
      @cart_item = CartItem.create(product_id: backoffice_order_params["product_line_1"], cart_id: @cart.id, quantity: 1, status: "active") unless backoffice_order_params["product_line_1"].blank?
      @cart_item = CartItem.create(product_id: backoffice_order_params["product_line_2"], cart_id: @cart.id, quantity: 1, status: "active") unless backoffice_order_params["product_line_2"].blank?
      @cart_item = CartItem.create(product_id: backoffice_order_params["product_line_3"], cart_id: @cart.id, quantity: 1, status: "active") unless backoffice_order_params["product_line_3"].blank?
      @cart_item = CartItem.create(product_id: backoffice_order_params["product_line_4"], cart_id: @cart.id, quantity: 1, status: "active") unless backoffice_order_params["product_line_4"].blank?
      @backoffice_order.cart_id = @cart.id

      if @backoffice_order.save
        product1 = false
        product2 = false
        product3 = false
        product4 = false
        product1 = Product.find(backoffice_order_params["product_line_1"]) unless backoffice_order_params["product_line_1"].blank?
        product2 = Product.find(backoffice_order_params["product_line_2"]) unless backoffice_order_params["product_line_2"].blank?
        product3 = Product.find(backoffice_order_params["product_line_3"]) unless backoffice_order_params["product_line_3"].blank?
        product4 = Product.find(backoffice_order_params["product_line_4"]) unless backoffice_order_params["product_line_4"].blank?

        @backoffice_order_item_1 = OrderItem.create(order_id: @backoffice_order.id, product_id: product1.id, price_cents: product1.price_cents, quantity: 1, status: "active" ) if product1
        @backoffice_order_item_2 = OrderItem.create(order_id: @backoffice_order.id, product_id: product2.id, price_cents: product2.price_cents, quantity: 1, status: "active" ) if product2
        @backoffice_order_item_3 = OrderItem.create(order_id: @backoffice_order.id, product_id: product3.id, price_cents: product3.price_cents, quantity: 1, status: "active" ) if product3
        @backoffice_order_item_4 = OrderItem.create(order_id: @backoffice_order.id, product_id: product4.id, price_cents: product4.price_cents, quantity: 1, status: "active" ) if product4
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
        puts @backoffice_order.errors.inspect
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

      # Custom authorization for order show action
      def authorize_order_access
        unless current_user.admin? || current_user.auxiliary? || current_user.driver?
          raise CanCan::AccessDenied
        end
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_order_params
        params.require(:order).permit(:efact_type, :customer_comments, :process_comments, :delivery_comments, :user_id, :amount_cents, :shipping_amount_cents, :stage, :shipping_address_id, :billing_address_id, :coupon_id, :payment_status, :status, :points_redeemed_amount, order_items_attributes: [:id, :product_id, :price_cents, :quantity, :status, :_destroy])
      end
  end
end
