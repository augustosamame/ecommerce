class SendOrderEmailsWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Ecommerce::Order.find(order_id)
    user = order.user
    AdminMailer.new_order_email(user, order).deliver! #unless Rails.env == "development"
    UserMailer.new_order_email(user, order).deliver! #unless Rails.env == "development"
  end
end
