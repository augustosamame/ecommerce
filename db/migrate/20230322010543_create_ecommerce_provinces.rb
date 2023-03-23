class CreateEcommerceProvinces < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_provinces do |t|
      t.string :province, null: false
      t.string :district, null: false
      t.integer :delivery_zone, default: 0
      t.integer :delivery_formula, default: 0
      t.integer :cost_first_kilo_cents
      t.integer :cost_per_kilo_cents
      t.integer :delivery_time_in_days
      t.integer :status, default: 0
      t.integer :priority, default: 1

      t.timestamps
    end
  end
end
