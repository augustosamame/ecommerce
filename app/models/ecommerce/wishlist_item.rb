module Ecommerce
  class WishlistItem < ApplicationRecord
    belongs_to :wishlist
    belongs_to :product

    def line_total(current_user)
      self.quantity * self.product.current_price(current_user)
    end
  end
end
