module Ecommerce
  class ProductSkuProperty < ApplicationRecord
    belongs_to :product_sku
    belongs_to :product_variant
  end
end
