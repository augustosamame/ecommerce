module Ecommerce

  class CartItem < ApplicationRecord
    belongs_to :cart
    belongs_to :product

    def line_total
      (self.quantity || 0) * (self.try(:product).try(:current_price) || 0)
    end

  end

end
