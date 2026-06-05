class SendAllCampaignEmailsWorker
  include Sidekiq::Worker

  # Seconds between each recipient's send. Raised from 0.5s to ease off SES /
  # receiver bulk-rate throttling and protect sender reputation on big blasts.
  DELAY_PER_EMAIL = 2

  # Seeded monitoring inboxes dropped into the blast so we can confirm
  # deliverability at the beginning, middle and end of the run. Only used for
  # real bulk sends (include_controls), never for test sends.
  CONTROL_EMAILS = {
    start:  "augusto+start@devtechperu.com",
    middle: "augusto+middle@devtechperu.com",
    last:   "augusto+last@devtechperu.com"
  }.freeze

  def perform(user_ids, coupon_id, campaign_id, include_controls = false)
    total     = user_ids.size
    mid_index = total / 2

    schedule_control(:start, 0, coupon_id, campaign_id) if include_controls

    user_ids.each_with_index do |user_id, index|
      delay = (index + 1) * DELAY_PER_EMAIL
      SendEachCampaignEmailWorker.perform_in(delay.seconds, user_id, coupon_id, campaign_id)
      schedule_control(:middle, delay, coupon_id, campaign_id) if include_controls && index == mid_index
    end

    if include_controls
      last_delay = (total + 1) * DELAY_PER_EMAIL
      schedule_control(:last, last_delay, coupon_id, campaign_id)
    end
  end

  private

  def schedule_control(position, delay_seconds, coupon_id, campaign_id)
    email = CONTROL_EMAILS[position]
    return unless email
    SendControlCampaignEmailWorker.perform_in(delay_seconds.seconds, email, coupon_id, campaign_id)
  end
end
