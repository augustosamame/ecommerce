class CreateEcommerceOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_order_items do |t|
      t.references :order
      t.integer :product_id
      t.integer :price_cents, default: 0
      t.integer :quantity, default: 0
      t.integer :status

      t.timestamps
    end
  end
end
