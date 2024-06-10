class SendEachCampaignEmailWorker
  include Sidekiq::Worker

  def perform(user_id, coupon_id, campaign_id)
    user = User.find(user_id)
    user_with_email_suppressed_exists = User.where(email: user.email, email_suppressed: true).first
    unless user_with_email_suppressed_exists || user.email.blank?
      coupon = Ecommerce::Coupon.find_by(id: coupon_id)
      campaign = Ecommerce::Campaign.find(campaign_id)
      UserMailer.send_campaign_email(user, coupon, campaign).deliver!
    end
  end
end