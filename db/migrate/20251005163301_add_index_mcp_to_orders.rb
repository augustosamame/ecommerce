class AddIndexMcpToOrders < ActiveRecord::Migration[7.0]
  def change
    add_index :ecommerce_orders, :status
    add_index :ecommerce_orders, :payment_status
    add_index :ecommerce_orders, :stage
    add_index :ecommerce_orders, :amount_cents
    add_index :ecommerce_orders, :discount_amount_cents
    add_index :ecommerce_orders, :coupon_id
  end
end