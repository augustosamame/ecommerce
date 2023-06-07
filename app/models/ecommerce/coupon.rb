module Ecommerce
  class Coupon < ApplicationRecord
    has_many :orders
    #has_many :products
    has_and_belongs_to_many :products, join_table: :coupons_products

    enum status: {active: 0, inactive: 1}
    enum coupon_type: {percentage_discount: 0, fixed_discount_with_threshold: 1, fixed_discount_without_threshold: 2, percentage_discount_per_product: 3}

    validates_presence_of :coupon_code, :coupon_type, :status

    validate :can_only_exist_one_always_on_coupon

    def self.one_time_coupon(order_user_id)
      charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
      dynamic_coupon_code = (0...6).map{ charset.to_a[rand(charset.size)] }.join
      dynamic_coupon = Coupon.create(
        coupon_code: dynamic_coupon_code,
        coupon_type: 'percentage_discount',
        discount_percentage_decimal: 5.0,
        start_date: Time.now,
        end_date: Time.now + 3.days,
        max_uses_per_user: 1,
        max_uses: 1,
        current_uses: 0,
        free_shipping: false,
        status: "active",
        dynamic: true,
        dynamic_user_id: order_user_id
      )
    end

    def clear_all_expired_dynamic_coupons
      Ecommerce::Coupon.where("end_date < ? AND dynamic = ?", Time.now, true).destroy_all
    end

    def can_only_exist_one_always_on_coupon
      if self.always_on_active
        coupon_always_on_already_exists = Ecommerce::Coupon.where(always_on_active: true).where.not(id: self.id).first
        if coupon_always_on_already_exists
          errors.add(:always_on_active, 'There is already a coupon with Always On active.')
        end
      end
    end

  end
end
