class CreateEcommerceSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_suppliers do |t|
      t.string :name
      t.string :logo
      t.string :tax_id
      t.integer :tax_id_type
      t.integer :default_hours_lead_time

      t.timestamps
    end
  end
end
