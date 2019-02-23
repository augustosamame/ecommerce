class SendNextOrderCouponEmailsWorker
  include Sidekiq::Worker

  def perform(order_id, coupon_id)
    order = Ecommerce::Order.find(order_id)
    coupon = Ecommerce::Coupon.find(coupon_id)
    user = order.user
    UserMailer.next_order_coupon_email(user, order, coupon).deliver! #unless Rails.env == "development"
  end
end
