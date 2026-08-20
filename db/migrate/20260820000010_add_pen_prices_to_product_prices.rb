class AddPenPricesToProductPrices < ActiveRecord::Migration[7.0]
  # B2B pricelists (supermarkets) are quoted in soles as STATIC numbers — no
  # exchange-rate conversion. The existing price_cents columns stay as they
  # are because Product#current_price still serves them to store users on a
  # pricelist, where the storefront is USD; reinterpreting them as soles
  # would silently multiply those prices by ~3.5.
  def change
    add_column :ecommerce_product_prices, :pen_price_cents, :integer
    add_column :ecommerce_product_prices, :pen_discounted_price_cents, :integer
  end
end
