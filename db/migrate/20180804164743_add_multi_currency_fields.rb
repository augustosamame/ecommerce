class AddMultiCurrencyFields < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_products, :usd_price_cents, :integer, default: 0
    add_column :ecommerce_products, :usd_discounted_price_cents, :integer, default: 0
    add_column :ecommerce_orders, :currency, :string
    add_column :ecommerce_order_items, :currency, :string
  end
end
