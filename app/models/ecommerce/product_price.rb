module Ecommerce
  class ProductPrice < ApplicationRecord
    belongs_to :pricelist
    belongs_to :product

    monetize :price_cents
    monetize :discounted_price_cents
    monetize :usd_price_cents
    monetize :usd_discounted_price_cents

  end
end
