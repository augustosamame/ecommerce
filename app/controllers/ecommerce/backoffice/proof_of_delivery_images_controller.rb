require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::ProofOfDeliveryImagesController < Backoffice::BaseController
    skip_authorization_check
    before_action :set_order
    before_action :ensure_driver_or_admin_access
    
    # POST /backoffice/orders/:order_id/proof_of_delivery_images
    def create
      @proof_of_delivery_image = @order.proof_of_delivery_images.build(proof_of_delivery_image_params)
      @proof_of_delivery_image.user = current_user

      if @proof_of_delivery_image.save
        if params[:return_to] == 'index'
          redirect_to backoffice_orders_path, notice: 'Imagen subida correctamente.'
        else
          redirect_to backoffice_order_path(@order), notice: 'Imagen subida correctamente.'
        end
      else
        if params[:return_to] == 'index'
          redirect_to backoffice_orders_path, alert: 'Error al subir la imagen. Por favor intente nuevamente.'
        else
          redirect_to backoffice_order_path(@order), alert: 'Error al subir la imagen. Por favor intente nuevamente.'
        end
      end
    end

    private

    def set_order
      @order = Ecommerce::Order.find(params[:order_id])
    end

    def ensure_driver_or_admin_access
      unless current_user&.driver? || current_user&.admin? || current_user&.auxiliary?
        raise CanCan::AccessDenied
      end
    end

    def proof_of_delivery_image_params
      params.require(:proof_of_delivery_image).permit(:proof_of_delivery)
    end
  end
end