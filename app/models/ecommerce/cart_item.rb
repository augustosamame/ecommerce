module Ecommerce
  class CartItem < ApplicationRecord
    belongs_to :cart
  end
end
