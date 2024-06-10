class SendAllCampaignEmailsWorker
  include Sidekiq::Worker

  def perform(user_ids, coupon_id, campaign_id)
    user_ids.each_with_index do |user_id, index|
      SendEachCampaignEmailWorker.perform_in(index * 0.5.seconds, user_id, coupon_id, campaign_id)
    end
  end
end