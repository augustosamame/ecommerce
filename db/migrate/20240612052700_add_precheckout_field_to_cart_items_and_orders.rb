class AddPrecheckoutFieldToCartItemsAndOrders < ActiveRecord::Migration[5.2]
  def change
    
    add_column :ecommerce_cart_items, :pre_checkout, :boolean
    add_column :ecommerce_order_items, :pre_checkout, :boolean
  end
end
