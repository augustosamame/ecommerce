class SendUnpaidToPaidInteraktWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Ecommerce::Order.find(order_id)
    if order.payment_status == 'unpaid'
      user = order.user
      Interakt.new.send_message({
        user_id: order.user.id,
        template: "unpaid_order_reminder_v2",
        language_code: "es",
        header_values: [],
        body_values: [self.user.name, self.id, "#{self.currency} #{self.amount.to_s}", self.friendly_shipping_address, "1"],
        button_values: {"0": ["#{self.id}"]}
      })
    end
  end
end
