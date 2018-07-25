module Ecommerce
  class Tax < ApplicationRecord

    has_many :product_taxes, inverse_of: :tax, dependent: :destroy

  end
end
