module Ecommerce
  class Province < ApplicationRecord

    enum status: {active: 0, inactive: 1}
    enum delivery_zone: {lima_metropolitana: 0, provincias: 1}

  end

  def delete_and_seed

    lima_metropolitana_districts = ['San Isidro', 'Miraflores', 'Barranco', 'Santiago de Surco', 'La Molina','Chorrillos','San Borja','San Luis','Surquillo','San Miguel','Pueblo Libre','La Victoria','Magdalena','Jesus María','Lince', 'Bellavista de Callao', 'La Perla', 'Breña', 'San Martin de Porras', 'Los Olivos', 'San Juan de Miraflores']

    Ecommerce::Province.delete_all
    lima_metropolitana_districts.each do |each_district|
      Ecommerce::Province.create(province: "Lima Metropolitana", district: each_district, delivery_zone: "lima_metropolitana", cost_per_kilo_cents: 1000, delivery_time_in_days: 1, status: "active", priority: 1)
    end
    Ecommerce::Province.create(province: "Lima Provincia", district: "Huaral", delivery_zone: "provincias", cost_per_kilo_cents: 5000, delivery_time_in_days: 2, status: "active", priority: 2)
    Ecommerce::Province.create(province: "Arequipa", district: "Arequipa", delivery_zone: "provincias", cost_per_kilo_cents: 5000, delivery_time_in_days: 3, status: "active", priority: 3)
  end

end
