module Ecommerce
  class ProductPrice < ApplicationRecord
    belongs_to :pricelist
    belongs_to :product

    monetize :price_cents
    monetize :discounted_price_cents
    monetize :usd_price_cents
    monetize :usd_discounted_price_cents

    before_save :set_discounted_price

    def set_discounted_price
      self.discounted_price_cents = self.price_cents
    end

  end
end
