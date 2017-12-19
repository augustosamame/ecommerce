module Ecommerce
  class Backoffice::ProductSku < ApplicationRecord
    belongs_to :product
    belongs_to :product_variant
  end
end
