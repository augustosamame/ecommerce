module Ecommerce
  class CartItem < ApplicationRecord
    belongs_to :cart
    belongs_to :product

    def line_total
      self.quantity * (self.product.current_price / 100)
    end
  end
end
