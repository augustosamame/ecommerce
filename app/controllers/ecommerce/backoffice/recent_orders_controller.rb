require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::RecentOrdersController < Backoffice::BaseController
    skip_authorization_check
    before_action :ensure_driver_access
    
    # GET /backoffice/recent_orders
    def index
      @recent_orders = Ecommerce::Order.includes(:user, :order_items, :proof_of_delivery_images)
                                       .order(created_at: :desc)
                                       .limit(50)
      
      # Use mobile layout for driver users on mobile devices
      if current_user&.driver? && helpers.browser.device.mobile?
        render layout: 'ecommerce/backoffice_mobile'
      end
    end

    private

    def ensure_driver_access
      redirect_to main_app.root_path unless current_user&.driver? || current_user&.admin?
    end
  end
end