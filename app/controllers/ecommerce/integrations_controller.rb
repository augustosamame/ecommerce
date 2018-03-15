require_dependency "ecommerce/application_controller"

module Ecommerce
  class IntegrationsController < ApplicationController
    #skip_before_action :authenticate_user!, only: [:show]
    #before_action :set_checkout, only: [:show, :edit, :update, :destroy]

    respond_to :json, :js

    # GET /checkout
    def get_shipping_quote
      raise "Shipping Integrator not defined. Set value of Ecommerce.shipping_integrator in ecommerce initializer" unless Ecommerce.shipping_integrator
      raise "missing parameters" unless params[:address] && params[:district]
      case Ecommerce.shipping_integrator
      when "Urbaner"
        case
        when @cart.cart_total < 30
          response = {:amount => 7.00}
        when @cart.cart_total < 50
          response = {:amount => 5.00}
        else
          response = {:amount => 0.00}
        end
        respond_to do |format|
          format.json { render json: response.to_json }
        end
      when "Olva"

      else
        raise "unrecognized Ecommerce.shipping_integrator"
      end
    end

    def create_electronic_invoice
      raise "Electronic Invoicing Integrator not defined. Set value of Ecommerce.electronic_invoicing in ecommerce initializer" unless Ecommerce.electronic_invoicing
      raise "missing parameters" unless params[:order]
      case Ecommerce.electronic_invoicing
      when "Nubefact"
        return true
      when "Sunat"
        return true
      when "Manual"
        return true
      else
        raise "unrecognized Ecommerce.electronic_invoicing"
      end
    end

  end
end
