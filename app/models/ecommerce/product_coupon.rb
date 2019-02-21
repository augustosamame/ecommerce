module Ecommerce
  class ProductCoupon < ApplicationRecord
    belongs_to :products
    belongs_to :coupons
  end
end
