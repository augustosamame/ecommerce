module Ecommerce
  class ProductVariant < ApplicationRecord
    belongs_to :product
  end
end
