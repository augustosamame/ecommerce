class SendOrderEmailsWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Ecommerce::Order.find(order_id)
    user = order.user
    #check payment method here as 30 seconds have passed and payment has already been processed
    last_payment = Ecommerce::Payment.where(order_id: order.id).try(:last)
    order.update(process_comments: last_payment.try(:payment_method).try(:name)) if last_payment
    AdminMailer.new_order_email(user, order).deliver! #unless Rails.env == "development"
    UserMailer.new_order_email(user, order).deliver! #unless Rails.env == "development"
  end
end
