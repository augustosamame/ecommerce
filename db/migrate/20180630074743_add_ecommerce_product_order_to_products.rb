class AddEcommerceProductOrderToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :ecommerce_products, :product_order, :integer, default: 0
    add_index :ecommerce_products, :product_order
  end
end
