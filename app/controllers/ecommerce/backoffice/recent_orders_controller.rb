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

      # Razón social of the comprobante the invoicing platform emitted for
      # each web order (invoice.external_ref == order id). Soft-referenced
      # so the engine still boots in hosts without the invoicing app.
      invoice_class = "Invoicing::Invoice".safe_constantize
      @razon_social_by_order_id = if invoice_class
        invoice_class.where(source: :expatshop, external_ref: @recent_orders.map { |o| o.id.to_s })
                     .where.not(status: :voided)
                     .includes(:client)
                     .order(id: :asc)
                     .each_with_object({}) { |inv, h| h[inv.external_ref] = inv.client&.razon_social }
      else
        {}
      end

      # Manual comprobantes/guías from the host's invoicing platform (same
      # DB) also get delivered by these drivers, but have no order to hang
      # photos on.
      @manual_invoices = if invoice_class
        invoice_class.where(source: :manual, invoice_type: [:boleta, :factura])
                     .where.not(status: :voided)
                     .where("created_at > ?", 30.days.ago)
                     .includes(:client, :guias, :proof_of_delivery_images)
                     .order(id: :desc).limit(30)
      else
        []
      end
      guia_class = "Invoicing::Guia".safe_constantize
      @manual_guias = if guia_class
        # Standalone guías (e.g. traslados between warehouses); guías tied
        # to a comprobante share its photos instead.
        guia_class.where(invoice_id: nil)
                  .where("created_at > ?", 30.days.ago)
                  .includes(:client, :proof_of_delivery_images)
                  .order(id: :desc).limit(30)
      else
        []
      end


      # Use mobile layout for driver users on mobile devices
      if current_user&.driver? && helpers.browser.device.mobile?
        render layout: 'ecommerce/backoffice_mobile'
      end
    end

    private

    # Any backoffice role (admin/auxiliary/driver — already gated by
    # Backoffice::BaseController#authorize_role) can view and upload POD photos.
    def ensure_driver_access
      redirect_to main_app.root_path unless current_user&.driver? || current_user&.admin? || current_user&.auxiliary?
    end
  end
end