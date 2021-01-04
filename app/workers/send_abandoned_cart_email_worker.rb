class SendAbandonedCartEmailWorker
  include Sidekiq::Worker

  def perform(cart_id)
    cart = Ecommerce::Cart.find(cart_id)
    user = cart.user
    cart.update(abandoned_email_sent: true)
    UserMailer.abandoned_cart_email(user, cart, nil).deliver! #unless Rails.env == "development"
  end
end
