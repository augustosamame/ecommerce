class AddWoocommerceOrderNumberToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_orders, :woocommerce_order_number, :string
  end
end
