# Sends a campaign email to a seeded monitoring address (see CONTROL_EMAILS in
# SendAllCampaignEmailsWorker). The address is not a real User, so we pass an
# in-memory User.new — never saved — which is enough for the mailer (it only
# reads .email and .id, and the campaign template renders @campaign, not @user).
class SendControlCampaignEmailWorker
  include Sidekiq::Worker

  def perform(email, coupon_id, campaign_id)
    coupon   = Ecommerce::Coupon.find_by(id: coupon_id)
    campaign = Ecommerce::Campaign.find(campaign_id)
    user     = User.new(email: email)
    UserMailer.send_campaign_email(user, coupon, campaign).deliver!
  end
end
