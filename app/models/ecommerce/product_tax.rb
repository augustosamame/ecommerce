module Ecommerce
  class ProductTax < ApplicationRecord

    belongs_to :tax
    belongs_to :product

  end
end
