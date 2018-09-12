require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::CouponsController < Backoffice::BaseController
    before_action :set_coupon, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::Coupon"

    # GET /coupons
    def index
      @coupons = Coupon.all
    end

    # GET /coupons/1
    def show
      @backoffice_products = @coupon.products
    end

    # GET /coupons/new
    def new
      @coupon = Coupon.new
      @coupon.status = "active"
    end

    # GET /coupons/1/edit
    def edit
    end

    # POST /coupons
    def create
      @coupon = Coupon.new(coupon_params)

      if @coupon.save
        redirect_to [:backoffice, @coupon], notice: 'Coupon was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /coupons/1
    def update
      if @coupon.update(coupon_params)
        redirect_to [:backoffice, @coupon], notice: 'Coupon was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /coupons/1
    def destroy
      @coupon.destroy
      redirect_to backoffice_coupons_url, notice: 'Coupon was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_coupon
        @coupon = Coupon.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def coupon_params
        params.require(:coupon).permit(:coupon_code, :coupon_type, :dicount_percentage, :discount_fixed, :discount_threshold, :start_date, :end_date, :max_uses_per_user, :max_uses, :current_uses, :free_shipping, :status)
      end
  end
end
