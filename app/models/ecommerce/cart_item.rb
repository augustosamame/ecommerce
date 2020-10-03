module Ecommerce

  class CartItem < ApplicationRecord
    belongs_to :cart
    belongs_to :product

    def line_total(current_user)
      (self.quantity || 0) * (self.try(:product).current_price(current_user) || 0)
    end

  end

end
