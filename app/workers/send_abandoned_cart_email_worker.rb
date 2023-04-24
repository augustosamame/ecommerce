class SendAbandonedCartEmailWorker
  include Sidekiq::Worker

  def perform(cart_id, coupon_id)
    cart = Ecommerce::Cart.find(cart_id)
    user = cart.user
    cart.update(abandoned_email_sent: true)
    if Ecommerce::Control.find_by(name: 'send_abandoned_cart_coupon').boolean_value
      coupon = Ecommerce::Coupon.find(coupon_id)
      UserMailer.abandoned_cart_email(user, cart, coupon).deliver! #unless Rails.env == "development"
    else
      UserMailer.abandoned_cart_email(user, cart, nil).deliver! #unless Rails.env == "development"
    end
  end
end
