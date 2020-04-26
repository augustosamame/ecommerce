require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::StockAlertsController < Backoffice::BaseController
    authorize_resource :class => "Ecommerce::StockAlert"

    # GET /stock_alerts
    def index
      @stock_alerts = StockAlert.all.order(:product_id, :user_id)
    end

    # DELETE /coupons/1
    def destroy
      @stock_alert = StockAlert.find(params[:id])
      @stock_alert.destroy
      redirect_to backoffice_stock_alerts_url, notice: 'Stock Alert was successfully destroyed.'
    end

  end
end
