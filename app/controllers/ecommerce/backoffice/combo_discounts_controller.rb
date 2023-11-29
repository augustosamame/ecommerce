require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::ComboDiscountsController < Backoffice::BaseController
    before_action :set_combo_discount, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::ComboDiscount"

    # GET /combo_discounts
    def index
      @combo_discounts = ComboDiscount.all.order(id: :desc)
    end

    # GET /combo_discounts/1
    def show
      
    end

    # GET /combo_discounts/new
    def new
      @combo_discount = ComboDiscount.new
    end

    # GET /combo_discounts/1/edit
    def edit
      
    end

    # POST /combo_discounts
    def create
      @combo_discount = ComboDiscount.new(combo_discount_params)

      if @combo_discount.save
        redirect_to [:backoffice, @combo_discount], notice: 'Combo Discount was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /combo_discounts/1
    def update
      if @combo_discount.update(combo_discount_params)
        redirect_to [:backoffice, @combo_discount], notice: 'Combo Discount was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /combo_discounts/1
    def destroy
      @combo_discount.destroy
      redirect_to backoffice_combo_discounts_url, notice: 'Combo Discount was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_combo_discount
        @combo_discount = ComboDiscount.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def combo_discount_params
        params.require(:combo_discount).permit(:name, :description_en, :description_es, :product_id_1, :qty_product_1, :discount_type, :discount_amount, :status, :product_id_2, :qty_product_2)
      end
  end
end