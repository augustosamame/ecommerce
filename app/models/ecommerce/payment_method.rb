module Ecommerce
  class PaymentMethod < ApplicationRecord
    has_many :payments

    enum status: {active: 1, inactive: 2}

  end
end
