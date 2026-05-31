class CreateEcommerceFreeProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_free_products do |t|
      t.boolean :active, default: false, null: false
      t.bigint :product_id

      t.timestamps
    end
    add_index :ecommerce_free_products, :product_id
  end
end
