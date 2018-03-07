module Ecommerce
  class OrderItem < ApplicationRecord
    belongs_to :order
    belongs_to :product

    def line_total
      self.quantity * (self.price_cents / 100)
    end
  end
end
