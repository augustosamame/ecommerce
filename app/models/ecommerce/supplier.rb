module Ecommerce
  class Supplier < ApplicationRecord
    has_many :products, inverse_of: :supplier, dependent: :restrict_with_error
  end
end
