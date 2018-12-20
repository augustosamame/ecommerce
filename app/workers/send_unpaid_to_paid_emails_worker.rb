class SendUnpaidToPaidEmailsWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Ecommerce::Order.find(order_id)
    user = order.user
    AdminMailer.update_to_paid_email(user, order).deliver! #unless Rails.env == "development"
    #UserMailer.update_to_paid_email(user, order).deliver! #unless Rails.env == "development"
  end
end
