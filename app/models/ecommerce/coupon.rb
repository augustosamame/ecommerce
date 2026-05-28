module Ecommerce
  class Coupon < ApplicationRecord
    has_many :orders
    #has_many :products
    has_and_belongs_to_many :products, join_table: :coupons_products

    enum status: {active: 0, inactive: 1}
    enum coupon_type: {percentage_discount: 0, fixed_discount_with_threshold: 1, fixed_discount_without_threshold: 2, percentage_discount_per_product: 3}

    validates_presence_of :coupon_code, :coupon_type, :status

    validate :can_only_exist_one_always_on_coupon
    validate :can_only_exist_one_first_app_purchase_coupon
    validate :validations_for_minimum_quantity_applies
    validate :validations_for_combo_applies

    # When a coupon is flagged as first-app-purchase, force its platform
    # flags to app-only so the backoffice user doesn't have to remember to
    # uncheck web. Runs before validation so the persisted record is always
    # consistent.
    before_validation :enforce_first_app_purchase_platform

    def self.one_time_coupon(order_user_id)
      charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
      dynamic_coupon_code = (0...6).map{ charset.to_a[rand(charset.size)] }.join
      dynamic_coupon = Coupon.create(
        coupon_code: "CT#{dynamic_coupon_code}",
        coupon_type: 'percentage_discount',
        discount_percentage_decimal: 5.0,
        start_date: Time.now,
        end_date: Time.now + 6.months,
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

    def enabled_for_platform?(platform)
      case platform.to_s
      when 'web' then web_enabled
      when 'app' then app_enabled
      else true
      end
    end

    # Returns the active first-app-purchase coupon iff `user` qualifies — i.e.
    # logged in and has zero active app orders. Returns nil otherwise. Used
    # by both the home banner and the checkout summary in the API.
    def self.first_app_purchase_for(user)
      return nil unless user
      coupon = Ecommerce::Coupon.where(first_app_purchase_active: true, status: :active).first
      return nil unless coupon
      coupon.eligible_for_first_app_purchase?(user) ? coupon : nil
    end

    def eligible_for_first_app_purchase?(user)
      return false unless first_app_purchase_active && user
      Ecommerce::Order.where(user_id: user.id, platform: 'app', status: 'active').none?
    end

    # Single source of truth for redemption checks shared by web and app.
    # Returns [ok?, error_message]. Cart-specific checks (minimum quantity,
    # combo, threshold) stay in the discount calculators since they need cart
    # context.
    def validate_redemption(user:, platform:)
      unless active?
        return [false, I18n.t('controllers.orders.calculate_coupon.coupon_inactive', default: 'Cupón inactivo')]
      end

      unless enabled_for_platform?(platform)
        key = platform.to_s == 'web' ? 'not_valid_for_web' : 'not_valid_for_app'
        return [false, I18n.t("controllers.orders.calculate_coupon.#{key}")]
      end

      if end_date.present? && Time.current > end_date
        return [false, I18n.t('controllers.orders.calculate_coupon.coupon_expired')]
      end

      if max_uses_per_user.to_i > 0 && user
        times_used_by_user = Ecommerce::Order.where(coupon_id: id, user_id: user.id, status: 'active').count
        if times_used_by_user >= max_uses_per_user
          return [false, I18n.t('controllers.orders.calculate_coupon.max_times_per_user_exceeded')]
        end
      end

      if max_uses.to_i > 0
        times_used = Ecommerce::Order.where(coupon_id: id, status: 'active').count
        if times_used >= max_uses
          return [false, I18n.t('controllers.orders.calculate_coupon.max_times_exceeded')]
        end
      end

      if first_app_purchase_active && !eligible_for_first_app_purchase?(user)
        return [false, I18n.t('controllers.orders.calculate_coupon.first_app_purchase_only', default: 'Cupón válido sólo en la primera compra desde la app')]
      end

      [true, nil]
    end

    def can_only_exist_one_always_on_coupon
      return unless self.always_on_active && self.active?

      scope = Ecommerce::Coupon.active.where(always_on_active: true).where.not(id: self.id)

      # Two active always-on coupons may coexist as long as they don't both
      # target the same platform. We only flag a conflict when the existing
      # coupon overlaps on web or on app with the one being saved.
      platform_clauses = []
      platform_clauses << "web_enabled = TRUE" if self.web_enabled
      platform_clauses << "app_enabled = TRUE" if self.app_enabled
      return if platform_clauses.empty?

      if scope.where(platform_clauses.join(' OR ')).exists?
        errors.add(:always_on_active, 'There is already an active Always On coupon for the same platform (web or app).')
      end
    end

    def can_only_exist_one_first_app_purchase_coupon
      return unless self.first_app_purchase_active && self.active?
      existing = Ecommerce::Coupon.active.where(first_app_purchase_active: true).where.not(id: self.id).first
      if existing
        errors.add(:first_app_purchase_active, 'There is already an active First App Purchase coupon.')
      end
    end

    def enforce_first_app_purchase_platform
      if self.first_app_purchase_active
        self.web_enabled = false
        self.app_enabled = true
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
