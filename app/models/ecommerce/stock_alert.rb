module Ecommerce
  class StockAlert < ApplicationRecord
    belongs_to :user
    belongs_to :product

    enum status: {active: 0, alerted: 1, inactive: 2}
  end
end
