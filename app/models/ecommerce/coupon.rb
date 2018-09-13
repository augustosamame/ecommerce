module Ecommerce
  class Coupon < ApplicationRecord
    has_many :orders
    has_many :products

    enum status: {active: 0, inactive: 1}
    enum coupon_type: {percentage_discount: 0, fixed_discount_with_threshold: 1, fixed_discount_without_threshold: 2, percentage_discount_per_product: 3}

    validates_presence_of :coupon_code, :coupon_type, :status
  end
end
