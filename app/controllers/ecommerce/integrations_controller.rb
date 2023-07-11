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
          cutoff_price = Ecommerce::Control.get_control_value("flat_shipping_cutoff_amount")
          if @cart.get_totals(current_user)[:tot_acum].to_f < cutoff_price
            response = {:amount => Ecommerce::Control.get_control_value("flat_shipping_under_cutoff_rate")}
          #when @cart.get_totals(current_user)[:tot_acum].to_f < 100
            #response = {:amount => 7.00}
          else
            response = {:amount => Ecommerce::Control.get_control_value("flat_shipping_over_cutoff_rate")}
          end
        when "provincias"
          #calculate shipping cost per kg here
          total_kgs = @cart.get_totals(current_user)[:tot_kgs]
          if total_kgs <= 1
            first_kg = 1
            extra_kgs = 0
          else
            first_kg = 1
            extra_kgs = ((total_kgs - 1).ceil).to_f
          end
          total_shipping_cost = ((first_kg * province.cost_first_kilo_cents.to_f) + (extra_kgs * province.cost_per_kilo_cents.to_f)) / 100
          response = {:amount => total_shipping_cost.to_f}
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
