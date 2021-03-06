module Ecommerce
  class PaymentMethod < ApplicationRecord
    has_many :payments

    enum status: {active: 1, inactive: 2}

    scope :is_active, -> { where(status: "active") }

  end
end
