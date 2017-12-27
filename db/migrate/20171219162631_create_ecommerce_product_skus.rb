class CreateEcommerceProductSkus < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_product_skus do |t|
      t.references :product
      t.string :sku
      t.string :name
      t.integer :price_cents
      t.integer :status
      t.integer :stock
      t.boolean :master, :default => false, :null => false

      t.timestamps
    end
    add_foreign_key :ecommerce_product_skus, :ecommerce_products, column: :product_id
  end
end
