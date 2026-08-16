require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::DiscountGroupsController < Backoffice::BaseController
    before_action :set_discount_group, only: [:show, :edit, :update, :destroy, :apply_discount]
    authorize_resource :class => "Ecommerce::DiscountGroup"

    # GET /backoffice/discount_groups
    def index
      @discount_groups = DiscountGroup.all.order(id: :desc)
    end

    # GET /backoffice/discount_groups/1
    def show
      @products = @discount_group.products.includes(:translations).order(:permalink)
    end

    # GET /backoffice/discount_groups/new
    def new
      @discount_group = DiscountGroup.new
    end

    # GET /backoffice/discount_groups/1/edit
    def edit
    end

    # POST /backoffice/discount_groups
    def create
      @discount_group = DiscountGroup.new(discount_group_params)

      if @discount_group.save
        redirect_to [:backoffice, @discount_group], notice: 'Discount Group was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/discount_groups/1
    def update
      if @discount_group.update(discount_group_params)
        redirect_to [:backoffice, @discount_group], notice: 'Discount Group was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/discount_groups/1
    def destroy
      @discount_group.destroy
      redirect_to backoffice_discount_groups_path, notice: 'Discount Group was successfully destroyed.'
    end

    # POST /backoffice/discount_groups/1/apply_discount
    # active "1": set each member product's discounted price from percentage.
    # active unchecked: remove the discounts (discounted price back to price).
    def apply_discount
      active = params[:active] == "1"
      applied, failed = @discount_group.apply_discount!(percentage: params[:percentage], active: active)

      notice = if active
        "Discount of #{params[:percentage]}% applied to #{applied} products."
      else
        "Discounts removed from #{applied} products."
      end
      notice += " Failed: #{failed.join('; ')}" if failed.any?
      redirect_to backoffice_discount_group_path(@discount_group), notice: notice
    rescue ArgumentError => e
      redirect_to backoffice_discount_group_path(@discount_group), alert: e.message
    end

    private

      def set_discount_group
        @discount_group = DiscountGroup.find(params[:id])
      end

      def discount_group_params
        params.require(:discount_group).permit(:name, :status)
      end
  end
end
