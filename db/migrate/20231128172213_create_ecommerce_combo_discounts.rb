class CreateEcommerceComboDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_combo_discounts do |t|
      t.string :name, null: false
      t.string :description_en, null: false
      t.string :description_es, null: false
      t.integer :product_id_1, null: false
      t.integer :qty_product_1, null: false
      t.integer :product_id_2
      t.integer :qty_product_2
      t.integer :discount_type, default: 0
      t.integer :discount_amount, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
