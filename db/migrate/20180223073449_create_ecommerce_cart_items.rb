class CreateEcommerceCartItems < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_cart_items do |t|
      t.references :cart
      t.integer :product_id
      t.integer :quantity
      t.integer :status

      t.timestamps
    end
  end
end
