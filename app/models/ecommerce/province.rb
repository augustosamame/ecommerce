module Ecommerce
  class Province < ApplicationRecord

    enum status: {active: 0, inactive: 1}
    enum delivery_zone: {lima_metropolitana: 0, provincias: 1}
    enum delivery_formula: {flat: 0, per_kg: 1}

    # ---------------------------------------------------------------------
    # Authoritative shipping quote. THE single implementation — both the web
    # (Ecommerce::IntegrationsController#get_shipping_quote) and the mobile API
    # (Api::V1::CheckoutController) must call this. The mobile API used to carry
    # its own copy of this logic, which drifted and charged customers either 0
    # (Lima districts store cost_*_kilo_cents = 0 because Lima is billed at the
    # flat Control rate, not per kilo) or a hardcoded 20 fallback.
    #
    # Returns a Float in USD: all catalog prices are stored in USD, so shipping
    # must be too, otherwise order totals mix currencies.
    # ---------------------------------------------------------------------
    def self.shipping_quote_usd(district:, cart:, user: nil)
      province = find_for_district(district)
      totals = cart.get_totals(user)

      case province&.delivery_zone
      when "lima_metropolitana"
        cutoff_price = Ecommerce::Control.get_control_value("flat_shipping_cutoff_amount").to_f
        if totals[:tot_acum].to_f < cutoff_price
          Ecommerce::Control.get_control_value("flat_shipping_under_cutoff_rate").to_f
        else
          Ecommerce::Control.get_control_value("flat_shipping_over_cutoff_rate").to_f
        end
      when "provincias"
        # First kilo is always billed; additional weight is rounded up per kilo.
        total_kgs = totals[:tot_kgs].to_f
        extra_kgs = total_kgs <= 1 ? 0.0 : (total_kgs - 1).ceil.to_f
        ((province.cost_first_kilo_cents.to_f) + (extra_kgs * province.cost_per_kilo_cents.to_f)) / 100
      else
        0.0
      end
    end

    # Districts are passed around as "Province - District" (see the districts
    # endpoint and the web checkout dropdown). Unknown/malformed values fall
    # back to lima_metropolitana, matching long-standing web behaviour — never
    # to an arbitrary flat charge.
    def self.find_for_district(district)
      shipping_province = district.to_s.split("-")[0].try(:strip)
      shipping_district = district.to_s.split("-")[1].try(:strip)
      find_by(province: shipping_province, district: shipping_district) ||
        find_by(delivery_zone: "lima_metropolitana")
    end

    def delete_and_seed

      lima_metropolitana_districts = ['San Isidro', 'Miraflores', 'Barranco', 'Santiago de Surco', 'La Molina','Chorrillos','San Borja','San Luis','Surquillo','San Miguel','Pueblo Libre','La Victoria','Magdalena','Jesus María','Lince', 'Bellavista Callao', 'La Perla', 'Breña', 'San Martin de Porras', 'Los Olivos', 'San Juan de Miraflores']

      Ecommerce::Province.delete_all
      lima_metropolitana_districts.each do |each_district|
        Ecommerce::Province.create(province: "Lima Metropolitana", district: each_district, delivery_zone: "lima_metropolitana", delivery_formula: 'flat', cost_per_kilo_cents: 0, cost_first_kilo_cents: 0, delivery_time_in_days: 1, status: "active", priority: 1)
      end
      Ecommerce::Province.create(province: "Lima Provincia", district: "Huaral", delivery_zone: "provincias", delivery_formula: 'per_kg', cost_per_kilo_cents: 400, cost_first_kilo_cents: 60, delivery_time_in_days: 2, status: "active", priority: 2)
      Ecommerce::Province.create(province: "Arequipa", district: "Arequipa", delivery_zone: "provincias", delivery_formula: 'per_kg', cost_per_kilo_cents: 800, cost_first_kilo_cents: 120, delivery_time_in_days: 3, status: "active", priority: 3)
    end

  end

end
