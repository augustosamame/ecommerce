class CreateEcommerceStockAlerts < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_stock_alerts do |t|
      t.references :user
      t.references :product
      t.integer :status, :default => 0

      t.timestamps
    end
    add_foreign_key :ecommerce_stock_alerts, :users, column: :user_id
    add_foreign_key :ecommerce_stock_alerts, :ecommerce_products, column: :product_id
  end
end
