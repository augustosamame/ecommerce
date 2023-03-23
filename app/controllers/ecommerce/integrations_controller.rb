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
        shipping_province = params[:district].split("-")[0].try(:strip)
        shipping_district = params[:district].split("-")[1].try(:strip)
        province = Province.find_by(province: shipping_province, district: shipping_district) || Province.find_by(delivery_zone: "lima_metropolitana") #if not found, use lima_metropolitana
        case province.delivery_zone
        when "lima_metropolitana"
          if @cart.get_totals(current_user)[:tot_acum].to_f < 30
            response = {:amount => 3.00}
          #when @cart.get_totals(current_user)[:tot_acum].to_f < 100
            #response = {:amount => 7.00}
          else
            response = {:amount => 0.00}
          end
        when "provincias"
          #calculate shipping cost per kg here
          response = {:amount => 10.00}
        else
          response = {:amount => 0.00}
        end
        response[:currency] = session[:currency] || "usd"
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
