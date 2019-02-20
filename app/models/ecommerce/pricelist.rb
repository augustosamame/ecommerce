module Ecommerce
  class Pricelist < ApplicationRecord
    has_many :product_prices

    enum status: {active: 0, inactive: 1}

  end
end
