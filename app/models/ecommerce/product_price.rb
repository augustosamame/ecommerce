module Ecommerce
  class ProductPrice < ApplicationRecord
    belongs_to :pricelist
    belongs_to :product

    monetize :price_cents
    monetize :discounted_price_cents
    monetize :usd_price_cents
    monetize :usd_discounted_price_cents

    # B2B soles price: a static decimal(12,4) amount (e.g. 12.1668), never
    # converted with the exchange rate. Kept separate from the USD columns
    # above, which the web store still serves to users on a pricelist.
    validates :pen_price, numericality: { greater_than: 0 }, allow_nil: true

    before_save :set_discounted_price

    def set_discounted_price
      # "No discount" = discounted equals price (Product#discounted?
      # convention). Only fill the blanks: the old unconditional overwrite
      # silently discarded every discounted price ever entered.
      if discounted_price_cents.blank? || discounted_price_cents.zero? || discounted_price_cents > price_cents
        self.discounted_price_cents = price_cents
      end
      # Same convention on the soles side.
      self.pen_discounted_price = pen_price if pen_discounted_price.blank?
    end

    # Static soles amount used by B2B invoicing (nil when the row only
    # carries the storefront USD price).
    def invoicing_pen_amount
      [pen_price, pen_discounted_price].compact.min
    end
  end
end
