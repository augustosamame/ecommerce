require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::AccountingCodeFamiliesController < Backoffice::BaseController
    before_action :set_backoffice_accounting_code_family, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::AccountingCodeFamily"

    # GET /backoffice/accounting_code_families
    def index
      @backoffice_accounting_code_families = AccountingCodeFamily.all.order(:accounting_code)
    end

    # GET /backoffice/accounting_code_families/1
    def show
    end

    # GET /backoffice/accounting_code_families/new
    def new
      @backoffice_accounting_code_family = AccountingCodeFamily.new
    end

    # GET /backoffice/accounting_code_families/1/edit
    def edit
    end

    # POST /backoffice/accounting_code_families
    def create
      @backoffice_accounting_code_family = AccountingCodeFamily.new(backoffice_accounting_code_family_params)

      if @backoffice_accounting_code_family.save
        redirect_to backoffice_accounting_code_family_path(@backoffice_accounting_code_family), notice: 'Accounting Code Family was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/accounting_code_families/1
    def update
      if @backoffice_accounting_code_family.update(backoffice_accounting_code_family_params)
        redirect_to backoffice_accounting_code_family_path(@backoffice_accounting_code_family), notice: 'Accounting Code Family was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/accounting_code_families/1
    def destroy
      @backoffice_accounting_code_family.destroy
      redirect_to backoffice_accounting_code_families_url, notice: 'Accounting Code Family was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_accounting_code_family
        @backoffice_accounting_code_family = AccountingCodeFamily.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_accounting_code_family_params
        params.require(:accounting_code_family).permit(:accounting_code, :product_family)
      end
  end
end
