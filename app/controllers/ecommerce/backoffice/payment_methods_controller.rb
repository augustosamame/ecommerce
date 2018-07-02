require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::PaymentMethodsController < Backoffice::BaseController
    before_action :set_backoffice_payment_method, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::PaymentMethod"

    # GET /backoffice/payment_methods
    def index
      @backoffice_payment_methods = PaymentMethod.all.order(:id)
    end

    # GET /backoffice/payment_methods/1
    def show
    end

    # GET /backoffice/payment_methods/new
    def new
      @backoffice_payment_method = PaymentMethod.new
    end

    # GET /backoffice/payment_methods/1/edit
    def edit
    end

    # POST /backoffice/payment_methods
    def create
      @backoffice_payment_method = PaymentMethod.new(backoffice_payment_method_params)

      if @backoffice_payment_method.save
        redirect_to backoffice_payment_method_path(@backoffice_payment_method), notice: t('.created')
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/payment_methods/1
    def update
      if @backoffice_payment_method.update(backoffice_payment_method_params)
        redirect_to backoffice_payment_method(@backoffice_payment_method), notice: t('.destroyed')
      else
        render :edit
      end
    end

    # DELETE /backoffice/payment_methods/1
    def destroy
      @backoffice_payment_method.destroy
      redirect_to backoffice_payment_methods_url, notice: t('.destroyed')
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_payment_method
        @backoffice_payment_method = PaymentMethod.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_payment_method_params
        params.require(:payment_method).permit(:name, :logo, :logo_cache, :processor, :account, :key, :secret, :callback_url, :success_marks_as_paid, :pre_message, :post_message)
      end
  end
end
