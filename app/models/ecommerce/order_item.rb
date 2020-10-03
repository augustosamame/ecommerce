module Ecommerce
  class OrderItem < ApplicationRecord
    belongs_to :order
    belongs_to :product

    monetize :price_cents, with_model_currency: :currency

    enum status: {active: 0, inactive: 1, void: 2 }

    def line_total(current_user)
      self.quantity * (self.price)
    end
  end
end
