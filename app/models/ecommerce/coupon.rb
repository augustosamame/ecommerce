module Ecommerce
  class Coupon < ApplicationRecord
    has_many :orders
    #has_many :products
    has_and_belongs_to_many :products, join_table: :coupons_products

    enum status: {active: 0, inactive: 1}
    enum coupon_type: {percentage_discount: 0, fixed_discount_with_threshold: 1, fixed_discount_without_threshold: 2, percentage_discount_per_product: 3}

    validates_presence_of :coupon_code, :coupon_type, :status

    validate :can_only_exist_one_always_on_coupon
    validate :validations_for_minimum_quantity_applies
    validate :validations_for_combo_applies

    def self.one_time_coupon(order_user_id)
      charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
      dynamic_coupon_code = (0...6).map{ charset.to_a[rand(charset.size)] }.join
      dynamic_coupon = Coupon.create(
        coupon_code: "CART#{dynamic_coupon_code}",
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

    def self.clear_all_expired_dynamic_coupons
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

    def validations_for_minimum_quantity_applies
      if self.minimum_quantity_applies
        product = Ecommerce::Product.find_by(id: self.minimum_quantity_product)
        if !product
          errors.add(:minimum_quantity_product, 'Product does not exist.')
        end
        if minimum_quantity < 1
          errors.add(:minimum_quantity, 'Minimum quantity must be greater than 0.')
        end
        if !['percentage_discount', 'fixed_discount_without_threshold'].include?(self.coupon_type)
          errors.add(:coupon_type, 'Minimum Qty coupons must be of type: Percentage Discount or Fixed Discount without Threshold.')
        end
      end
    end

    def validations_for_combo_applies
      if self.combo_applies
        if !self.combo_products.blank? && self.combo_products[0].split(",").length < 2
          errors.add(:combo_products, 'Combo coupons must have at least 2 products.')
        end
        products = Ecommerce::Product.where(id: self.combo_products[0].split(","))
        if products.blank? || products.length != self.combo_products[0].split(",").length
          errors.add(:combo_products, 'All products must exist.')
        end
        if !['percentage_discount', 'fixed_discount_without_threshold'].include?(self.coupon_type)
          errors.add(:coupon_type, 'Combo coupons must be of type: Percentage Discount or Fixed Discount without Threshold.')
        end
      end
    end

  end
end
