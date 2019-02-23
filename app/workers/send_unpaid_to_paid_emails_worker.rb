class SendUnpaidToPaidEmailsWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Ecommerce::Order.find(order_id)
    user = order.user
    last_payment = Ecommerce::Payment.where(order_id: order.id).try(:last)
    order.update(process_comments: last_payment.try(:payment_method).try(:name)) if last_payment
    AdminMailer.update_to_paid_email(user, order).deliver! #unless Rails.env == "development"
    #UserMailer.update_to_paid_email(user, order).deliver! #unless Rails.env == "development"
  end
end
