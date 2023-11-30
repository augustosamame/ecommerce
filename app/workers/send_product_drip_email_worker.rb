class SendProductDripEmailWorker
  include Sidekiq::Worker

  def perform(user_id, coupon_id, campaign_id)
    user = User.find(user_id)
    coupon = Ecommerce::Coupon.find(coupon_id)
    campaign = Ecommerce::Campaign.find(campaign_id)
    UserMailer.product_drip_email(user, coupon, campaign).deliver! #unless Rails.env == "development"
  end
end
