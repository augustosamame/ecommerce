require_dependency "ecommerce/application_controller"

module Ecommerce
  # Driver photo uploads for MANUAL invoicing comprobantes/guías — documents
  # created directly in the host's invoicing platform, with no
  # Ecommerce::Order behind them. Drivers stay inside the backoffice; the
  # photo lands on the shared proof_of_delivery_images table via the
  # invoicing_* foreign keys, so it also shows up in the invoicing platform.
  class Backoffice::ManualDeliveryPodsController < Backoffice::BaseController
    skip_authorization_check
    before_action :ensure_driver_or_admin_access

    # POST /backoffice/manual_deliveries/pods (doc_type=invoice|guia, doc_id)
    def create
      klass_name, fk = case params[:doc_type]
                       when "invoice" then ["Invoicing::Invoice", :invoicing_invoice_id]
                       when "guia"    then ["Invoicing::Guia", :invoicing_guia_id]
                       end
      doc = klass_name && klass_name.safe_constantize&.find_by(id: params[:doc_id])
      if doc.nil?
        redirect_to backoffice_recent_orders_path, alert: "Documento no encontrado." and return
      end

      pod = Ecommerce::ProofOfDeliveryImage.new(pod_params)
      pod.user = current_user
      pod[fk] = doc.id

      if pod.save
        redirect_to backoffice_recent_orders_path, notice: "Imagen subida para #{doc.number}."
      else
        redirect_to backoffice_recent_orders_path, alert: "Error al subir la imagen. Por favor intente nuevamente."
      end
    end

    private

    def ensure_driver_or_admin_access
      unless current_user&.driver? || current_user&.admin? || current_user&.auxiliary?
        raise CanCan::AccessDenied
      end
    end

    def pod_params
      params.require(:proof_of_delivery_image).permit(:proof_of_delivery)
    end
  end
end
