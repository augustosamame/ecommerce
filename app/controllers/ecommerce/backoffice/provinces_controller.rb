require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::ProvincesController < Backoffice::BaseController
    before_action :set_backoffice_province, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::Province"

    # GET /backoffice/provinces
    def index
      @backoffice_provinces = Province.all.order(priority: :asc)
    end

    # GET /backoffice/provinces/1
    def show
    end

    # GET /backoffice/provinces/new
    def new
      @backoffice_province = Province.new
    end

    # GET /backoffice/provinces/1/edit
    def edit
    end

    # POST /backoffice/provinces
    def create
      @backoffice_province = Province.new(backoffice_province_params)

      if @backoffice_province.save
        redirect_to backoffice_provinces_path, notice: 'Province was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/provinces/1
    def update
      if @backoffice_province.update(backoffice_province_params)
        redirect_back fallback_location: root_path, notice: 'Province was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/provinces/1
    def destroy
      @backoffice_province.destroy
      flash[:notice] = 'Province was successfully destroyed.'
      flash.keep(:notice)
      redirect_to request.referrer
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_province
        @backoffice_province = Province.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_province_params
        params.require(:province).permit(:province, :district, :delivery_zone, :delivery_formula, :cost_first_kilo_cents, :cost_per_kilo_cents, :delivery_time_in_days, :priority, :status)
      end
  end
end
