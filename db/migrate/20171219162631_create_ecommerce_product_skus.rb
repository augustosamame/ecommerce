class CreateEcommerceProductSkus < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_product_skus do |t|
      t.references :product
      t.string :sku, :null => false, :unique => true
      t.string :name
      t.integer :price_cents, :default => 0,  :null => false
      t.integer :cost_cents, :default => 0,  :null => false
      t.integer :status, :default => 0
      t.decimal :stock,     :precision => 8, :scale => 2, :default => 0.0,  :null => false
      t.decimal :stock_pending_to_customer,     :precision => 8, :scale => 2, :default => 0.0,  :null => false
      t.decimal :stock_pending_from_supplier,     :precision => 8, :scale => 2, :default => 0.0,  :null => false
      t.boolean :master, :default => false, :null => false
      t.datetime :deleted_at

      t.timestamps
    end
    add_foreign_key :ecommerce_product_skus, :ecommerce_products, column: :product_id
  end
end
