module Ecommerce
  class WishlistItem < ApplicationRecord
    belongs_to :wishlist
    belongs_to :product

    def line_total
      self.quantity * (self.product.current_price / 100)
    end
  end
end
