require_dependency "ecommerce/application_controller"

module Ecommerce
  class PaymentsController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}"
    #before_action :set_payment, only: [:show]

    authorize_resource

  end
end
