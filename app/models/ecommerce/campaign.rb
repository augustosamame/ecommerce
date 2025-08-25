module Ecommerce
  class Campaign < ApplicationRecord
    belongs_to :coupon, optional: true
    belongs_to :audience, optional: true

    enum campaign_type: {next_purchase_email: 0, bulk_email: 1, product_drip_email: 2}
    enum status: {inactive: 0, active: 1}

    validates :link, format: URI::regexp(%w[http https]), :allow_blank => true
    validate :product_drip_email_fields_exist, if: :product_drip_email?

    mount_uploader :image, Ecommerce::CampaignImageUploader

    def product_drip_email_fields_exist
      if self.drip_base_coupon_id.blank? || self.drip_product_id.blank? || self.drip_days_after.blank?
        errors.add(:product_drip_email_fields, "Drip email fields can't be blank for drip email campaigns")
      end
    end

    def self.send_product_drip_emails
      campaigns = Campaign.where(status: "active", campaign_type: "product_drip_email")
      campaigns.each do |campaign|
        target_date = Date.today - campaign.drip_days_after.to_i.days
        order_item_ids = Ecommerce::OrderItem.where('DATE(created_at) = ?', target_date).where(product_id: campaign.drip_product_id).pluck(:id).uniq
        order_ids = Ecommerce::OrderItem.where(id: order_item_ids).pluck(:order_id).uniq
        matching_users = Ecommerce::Order.where(id: order_ids).where(payment_status: "paid").pluck(:user_id).uniq
        matching_users.each do |user_id|
          charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
          dynamic_coupon_code = (0...6).map{ charset.to_a[rand(charset.size)] }.join
          original_coupon = Ecommerce::Coupon.find(campaign.drip_base_coupon_id)
          dynamic_coupon = Ecommerce::Coupon.create(
            coupon_code: "DR#{dynamic_coupon_code}",
            coupon_type: original_coupon.coupon_type,
            discount_fixed: original_coupon.discount_fixed,
            discount_percentage_decimal: original_coupon.discount_percentage_decimal,
            discount_threshold: original_coupon.discount_threshold,
            start_date: original_coupon.start_date,
            end_date: Time.now + 14.days,
            max_uses_per_user: original_coupon.max_uses_per_user,
            max_uses: original_coupon.max_uses,
            current_uses: 0,
            free_shipping: original_coupon.free_shipping,
            status: "active",
            dynamic: true,
            dynamic_user_id: user_id
            )
          products_with_this_coupon = original_coupon.products
          products_with_this_coupon.each do |product|
            product.coupons << dynamic_coupon
          end
          SendProductDripEmailWorker.perform_in(6.seconds, user_id, dynamic_coupon.id, campaign.id)
        end
      end
    end

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
          end_date: Time.now + 14.days,
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

    def self.send_drip_emails
      drip_email_1_active = Ecommerce::Control.find_by(name: 'drip_email_1_active')
      if drip_email_1_active.get_control_value == true
        drip_email_1_event_type = Ecommerce::Control.find_by(name: 'drip_email_1_event_type').get_control_value
        drip_email_1_days_after_event = Ecommerce::Control.find_by(name: 'drip_email_1_days_after_event').get_control_value
        drip_email_1 = Ecommerce::Control.find_by(name: 'drip_email_1').get_control_value
        #list of users who signed up 7 days ago
        case drip_email_1_event_type
        when 'user_signup'
          target_date = Date.today - drip_email_1_days_after_event.to_i.days
          user_ids = User.where('DATE(created_at) = ?', target_date ).pluck(:id).uniq
        when 'user_purchase'
        end
        user_ids.each do |user_id|
          SendDripEmailWorker.perform_async(user_id, drip_email_1)
        end
      end

      drip_email_2_active = Ecommerce::Control.find_by(name: 'drip_email_2_active')
      if drip_email_2_active.get_control_value == true
        drip_email_2_event_type = Ecommerce::Control.find_by(name: 'drip_email_2_event_type').get_control_value
        drip_email_2_days_after_event = Ecommerce::Control.find_by(name: 'drip_email_2_days_after_event').get_control_value
        drip_email_2 = Ecommerce::Control.find_by(name: 'drip_email_2').get_control_value
        #list of users who signed up 7 days ago
        case drip_email_2_event_type
        when 'user_signup'
          target_date = Date.today - drip_email_2_days_after_event.to_i.days
          user_ids = User.where('DATE(created_at) = ?', target_date ).pluck(:id).uniq
        when 'user_purchase'
        end
        user_ids.each do |user_id|
          SendDripEmailWorker.perform_async(user_id, drip_email_2)
        end
      end

      drip_email_3_active = Ecommerce::Control.find_by(name: 'drip_email_3_active')
      if drip_email_3_active.get_control_value == true
        drip_email_3_event_type = Ecommerce::Control.find_by(name: 'drip_email_3_event_type').get_control_value
        drip_email_3_days_after_event = Ecommerce::Control.find_by(name: 'drip_email_3_days_after_event').get_control_value
        drip_email_3 = Ecommerce::Control.find_by(name: 'drip_email_3').get_control_value
        #list of users who signed up 7 days ago
        case drip_email_3_event_type
        when 'user_signup'
          target_date = Date.today - drip_email_3_days_after_event.to_i.days
          user_ids = User.where('DATE(created_at) = ?', target_date ).pluck(:id).uniq
        when 'user_purchase'
        end
        user_ids.each do |user_id|
          SendDripEmailWorker.perform_async(user_id, drip_email_3)
        end
      end
    end

  end
end
