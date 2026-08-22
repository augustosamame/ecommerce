class UseDecimalPenPriceOnProductPrices < ActiveRecord::Migration[7.0]
  # B2B (supermarket) prices need 4 decimals — S/ 12.1668 — which integer
  # céntimos cannot hold. Store soles directly as decimal(12,4) instead:
  # entering "12.1668" in soles is also far less error-prone than asking an
  # operator to convert to céntimos.
  def up
    add_column :ecommerce_product_prices, :pen_price, :decimal, precision: 12, scale: 4
    add_column :ecommerce_product_prices, :pen_discounted_price, :decimal, precision: 12, scale: 4

    execute <<~SQL
      UPDATE ecommerce_product_prices
         SET pen_price = pen_price_cents / 100.0,
             pen_discounted_price = pen_discounted_price_cents / 100.0
       WHERE pen_price_cents IS NOT NULL
    SQL

    remove_column :ecommerce_product_prices, :pen_price_cents
    remove_column :ecommerce_product_prices, :pen_discounted_price_cents
  end

  def down
    add_column :ecommerce_product_prices, :pen_price_cents, :integer
    add_column :ecommerce_product_prices, :pen_discounted_price_cents, :integer
    execute <<~SQL
      UPDATE ecommerce_product_prices
         SET pen_price_cents = ROUND(pen_price * 100),
             pen_discounted_price_cents = ROUND(pen_discounted_price * 100)
       WHERE pen_price IS NOT NULL
    SQL
    remove_column :ecommerce_product_prices, :pen_price
    remove_column :ecommerce_product_prices, :pen_discounted_price
  end
end
