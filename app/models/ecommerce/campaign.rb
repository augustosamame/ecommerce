module Ecommerce
  class Campaign < ApplicationRecord
    belongs_to :coupon

    enum campaign_type: {next_purchase_email: 0, bulk_email: 1}
    enum status: {inactive: 0, active: 1}

    def self.send_recipients(order_id)
      to_send = Campaign.find_by(status: "active", campaign_type: "next_purchase_email")
      if to_send
        SendNextOrderCouponEmailsWorker.perform_in(6.seconds, order_id, to_send.coupon.id)
      end
    end

  end
end
