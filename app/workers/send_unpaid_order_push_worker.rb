class SendUnpaidOrderPushWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Ecommerce::Order.find(order_id)
    return if order.stage == 'stage_void' || order.status == 'void'
    return unless order.payment_status == 'unpaid'

    user = order.user
    return if user.expo_push_token.blank?

    ExpoPush.new.send_notification({
      user_id: user.id,
      title: "¿Olvidaste algo?",
      body: "Tu pedido ##{order.id} aún está pendiente de pago. Total: #{order.currency} #{order.amount}.",
      data: { type: "unpaid_order", order_id: order.id }
    })
  end
end
