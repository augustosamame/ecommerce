class SendDripEmailWorker
  include Sidekiq::Worker

  def perform(user_id, drip_email)
    user = User.find(user_id)
    #coupon = Ecommerce::Coupon.find_by(id: coupon_id)
    UserMailer.send(drip_email, user).deliver! unless user.email.blank? #unless Rails.env == "development"
  end
end
