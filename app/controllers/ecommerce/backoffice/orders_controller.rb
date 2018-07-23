require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::OrdersController < Backoffice::BaseController
    before_action :set_backoffice_order, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::Order"

    def einvoice
      @backoffice_order = Order.find(params[:format])
      @order_details = Cart.find(@backoffice_order.id).cart_items.includes(:product)
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
        @backoffice_orders = Order.where(stage: params[:stage]).order(id: :desc)
      else
        @backoffice_orders = Order.all.order(id: :desc)
      end
    end

    # GET /backoffice/orders/1
    def show
      @order_details = Order.find(@backoffice_order.id).order_items.includes(:product)
      if @backoffice_order.efact_response_text == "OK"
        @epdf = @backoffice_order.efact_invoice_url
        @erefund_pdf = @backoffice_order.efact_refund_url
      else
        @einvoice_error_message = @backoffice_order.efact_response_text
      end
    end

    # GET /backoffice/orders/new
    def new
      @backoffice_order = Order.new(stage: "stage_new", payment_status: "unpaid", status: "active")
    end

    # GET /backoffice/orders/1/edit
    def edit
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
        params.require(:order).permit(:efact_type, :customer_comments, :process_comments, :delivery_comments, :user_id, :amount_cents, :shipping_amount_cents, :stage, :shipping_address_id, :billing_address_id, :coupon_id, :payment_status, :status, order_items_attributes: [:id, :product_id, :price_cents, :quantity, :status, :_destroy])
      end
  end
end
