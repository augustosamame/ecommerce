class CreateEcommerceTaxes < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_taxes do |t|
      t.string :tax_name
      t.string :tax_friendly_name
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
