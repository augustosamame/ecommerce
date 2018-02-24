module Ecommerce
  class CartItem < ApplicationRecord
    belongs_to :cart
    belongs_to :product
  end
end
