class SendEachPushCampaignNotificationWorker
  include Sidekiq::Worker

  def perform(user_id, coupon_id, push_campaign_id)
    user = User.find_by(id: user_id)
    return if user.blank? || user.expo_push_token.blank?

    push_campaign = Ecommerce::PushCampaign.find(push_campaign_id)
    coupon = Ecommerce::Coupon.find_by(id: coupon_id) if coupon_id.present?

    title = push_campaign.title
    body = push_campaign.body
    body = "#{body}\n\nCupón: #{coupon.coupon_code}" if coupon

    # Match the app's notification handler shape (camelCase, type === 'product').
    # When no target product is set, send no routing data so the app simply opens.
    data = { pushCampaignId: push_campaign.id }
    if push_campaign.target_product_id.present?
      data[:type] = "product"
      data[:productId] = push_campaign.target_product_id
    end
    data[:couponCode] = coupon.coupon_code if coupon

    ExpoPush.new.send_notification({
      user_id: user.id,
      title: title,
      body: body,
      data: data
    })
  end
end
