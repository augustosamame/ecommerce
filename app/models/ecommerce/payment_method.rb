module Ecommerce
  class PaymentMethod < ApplicationRecord
    has_many :payments

    enum status: {active: 1, inactive: 2}

    scope :active, -> { where(status: "active") }

    mount_uploader :logo, Ecommerce::PaymentMethodLogoUploader

  end
end
