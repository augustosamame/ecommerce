module Ecommerce
  class Province < ApplicationRecord

    enum status: {active: 0, inactive: 1}
    enum delivery_zone: {lima_metropolitana: 0, provincias: 1}
    enum delivery_formula: {flat: 0, per_kg: 1}

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
