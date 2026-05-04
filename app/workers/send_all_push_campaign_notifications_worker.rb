class SendAllPushCampaignNotificationsWorker
  include Sidekiq::Worker

  def perform(user_ids, coupon_id, push_campaign_id)
    user_ids.each_with_index do |user_id, index|
      SendEachPushCampaignNotificationWorker.perform_in(index * 0.1.seconds, user_id, coupon_id, push_campaign_id)
    end
  end
end
