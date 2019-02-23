class SendCampaignEmailWorker
  include Sidekiq::Worker

  def perform(user_id, coupon_id)
    user = User.find(user_id)
    coupon = Ecommerce::Coupon.find(coupon_id)
    UserMailer.send_campaign_email(user, coupon).deliver! #unless Rails.env == "development"
  end
end
