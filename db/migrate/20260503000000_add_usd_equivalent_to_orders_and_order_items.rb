class AddUsdEquivalentToOrdersAndOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :ecommerce_orders, :exchange_rate, :decimal, precision: 10, scale: 6
    add_column :ecommerce_orders, :amount_usd_cents, :integer
    add_column :ecommerce_orders, :shipping_amount_usd_cents, :integer
    add_column :ecommerce_orders, :discount_amount_usd_cents, :integer

    add_column :ecommerce_order_items, :price_usd_cents, :integer
    add_column :ecommerce_order_items, :exchange_rate, :decimal, precision: 10, scale: 6
  end
end
