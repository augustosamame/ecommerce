module Ecommerce
  class Audience < ApplicationRecord
    has_many :campaigns
    has_many :user_audiences

    enum status: {inactive: 0, active: 1}
    enum audience_type: {test: 0, email_campaign: 1}

    def self.send_recipients(order_id)
      order_user_id = Order.find(order_id).user_id
      to_send = Campaign.find_by(status: "active", campaign_type: "next_purchase_email")
      if to_send
        charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
        dynamic_coupon_code = (0...6).map{ charset.to_a[rand(charset.size)] }.join
        original_coupon = Coupon.find(to_send.coupon.id)
        dynamic_coupon = Coupon.create(
          coupon_code: dynamic_coupon_code,
          coupon_type: original_coupon.coupon_type,
          discount_fixed: original_coupon.discount_fixed,
          discount_percentage_decimal: original_coupon.discount_percentage_decimal,
          discount_threshold: original_coupon.discount_threshold,
          start_date: original_coupon.start_date,
          end_date: original_coupon.end_date,
          max_uses_per_user: original_coupon.max_uses_per_user,
          max_uses: original_coupon.max_uses,
          current_uses: 0,
          free_shipping: original_coupon.free_shipping,
          status: "active",
          dynamic: true,
          dynamic_user_id: order_user_id
          )
        products_with_this_coupon = original_coupon.products
        products_with_this_coupon.each do |product|
          product.coupons << dynamic_coupon
        end
        SendNextOrderCouponEmailsWorker.perform_in(6.seconds, order_id, dynamic_coupon.id, to_send.id)
      end
    end

  end
end
