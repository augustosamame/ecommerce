class CreateEcommerceComboComponents < ActiveRecord::Migration[7.0]
  def change
    add_column :ecommerce_products, :component_combo, :boolean, default: false

    create_table :ecommerce_combo_components do |t|
      t.references :product, null: false, foreign_key: { to_table: :ecommerce_products }
      t.references :component_product, null: false, foreign_key: { to_table: :ecommerce_products }
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end

    add_index :ecommerce_combo_components, [:product_id, :component_product_id], unique: true, name: 'index_combo_components_on_product_and_component'
  end
end
