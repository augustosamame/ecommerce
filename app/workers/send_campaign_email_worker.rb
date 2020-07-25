class SendCampaignEmailWorker
  include Sidekiq::Worker

  def perform(user_id, coupon_id, campaign_id)
    user = User.find(user_id)
    coupon = Ecommerce::Coupon.find_by(id: coupon_id)
    campaign = Ecommerce::Campaign.find(campaign_id)
    UserMailer.send_campaign_email(user, coupon, campaign).deliver! unless user.email.blank? #unless Rails.env == "development"
  end
end
