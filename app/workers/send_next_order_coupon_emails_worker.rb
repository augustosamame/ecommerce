class SendNextOrderCouponEmailsWorker
  include Sidekiq::Worker

  def perform(order_id, coupon_id, campaign_id)
    order = Ecommerce::Order.find(order_id)
    coupon = Ecommerce::Coupon.find(coupon_id)
    campaign = Ecommerce::Campaign.find(campaign_id)
    user = order.user
    UserMailer.next_order_coupon_email(user, order, coupon, campaign).deliver! #unless Rails.env == "development"
  end
end
