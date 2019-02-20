class CreateEcommerceProductPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_product_prices do |t|
      t.references :product
      t.references :pricelist
      t.integer :price_cents, :default => 0
      t.integer :discounted_price_cents, :default => 0
      t.integer :usd_price_cents, :default => 0
      t.integer :usd_discounted_price_cents, :default => 0

      t.timestamps
    end
  end
end
