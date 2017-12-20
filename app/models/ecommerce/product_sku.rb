module Ecommerce
  class ProductSku < ApplicationRecord
    belongs_to :product
    has_many :product_sku_properties
  end
end
