module Ecommerce
  class OrderItem < ApplicationRecord
    belongs_to :order
    belongs_to :product

    monetize :price_cents

    def line_total
      self.quantity * (self.price)
    end
  end
end
