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
      # Mirror the same "no discount = discounted equals price" convention on
      # the soles columns used by B2B invoicing.
      self.pen_discounted_price_cents = pen_price_cents if pen_discounted_price_cents.blank?
    end

    # Static soles price for B2B invoicing (nil when the row predates the
    # soles columns or only carries the storefront USD price).
    def invoicing_pen_cents
      [pen_price_cents, pen_discounted_price_cents].compact.min
    end

  end
end
