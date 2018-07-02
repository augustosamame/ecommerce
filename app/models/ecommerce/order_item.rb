module Ecommerce
  class OrderItem < ApplicationRecord
    belongs_to :order
    belongs_to :product

    monetize :price_cents

    enum status: {active: 0, inactive: 1, void: 2 }

    def line_total
      self.quantity * (self.price)
    end
  end
end
