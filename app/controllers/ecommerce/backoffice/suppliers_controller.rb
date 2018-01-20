require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::SuppliersController < Backoffice::BaseController
    before_action :set_backoffice_supplier, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::Supplier"

    # GET /backoffice/suppliers
    def index
      @backoffice_suppliers = Supplier.all
    end

    # GET /backoffice/suppliers/1
    def show
    end

    # GET /backoffice/suppliers/new
    def new
      @backoffice_supplier = Supplier.new
    end

    # GET /backoffice/suppliers/1/edit
    def edit
    end

    # POST /backoffice/suppliers
    def create
      @backoffice_supplier = Supplier.new(backoffice_supplier_params)

      if @backoffice_supplier.save
        redirect_to backoffice_supplier_path(@backoffice_supplier), notice: t('.created')
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/suppliers/1
    def update
      if @backoffice_supplier.update(backoffice_supplier_params)
        redirect_to backoffice_supplier(@backoffice_supplier), notice: t('.destroyed')
      else
        render :edit
      end
    end

    # DELETE /backoffice/suppliers/1
    def destroy
      @backoffice_supplier.destroy
      redirect_to backoffice_suppliers_url, notice: t('.destroyed')
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_supplier
        @backoffice_supplier = Supplier.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_supplier_params
        params.require(:supplier).permit(:name, :logo, :logo_cache, :tax_id, :tax_id_type, :default_hours_lead_time)
      end
  end
end
