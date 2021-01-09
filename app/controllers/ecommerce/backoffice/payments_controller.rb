require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::PaymentsController < Backoffice::BaseController
    authorize_resource :class => "Ecommerce::Payment"

    # GET /backoffice/payment_methods
    def index
      @backoffice_payments = Payment.all.order(id: :desc)
    end

  end
end
