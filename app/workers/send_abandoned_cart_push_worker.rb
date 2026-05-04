class SendAbandonedCartPushWorker
  include Sidekiq::Worker

  def perform(cart_id, coupon_id)
    cart = Ecommerce::Cart.find(cart_id)
    user = cart.user
    return if user.blank? || user.expo_push_token.blank?

    if Ecommerce::Control.find_by(name: 'send_abandoned_cart_coupon')&.boolean_value && coupon_id
      coupon = Ecommerce::Coupon.find_by(id: coupon_id)
      body = if coupon
        "Dejaste productos en tu carrito. Usa el cupón #{coupon.coupon_code} y termina tu compra."
      else
        "Tienes productos esperando en tu carrito. ¡Termina tu compra!"
      end
    else
      body = "Tienes productos esperando en tu carrito. ¡Termina tu compra!"
    end

    ExpoPush.new.send_notification({
      user_id: user.id,
      title: "Tu carrito te espera",
      body: body,
      data: { type: "abandoned_cart", cart_id: cart.id }
    })
  end
end
