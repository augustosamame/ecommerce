class SendUnpaidToPaidEmailsWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Ecommerce::Order.find(order_id)
    user = order.user
    last_payment = Ecommerce::Payment.where(order_id: order.id).try(:last)
    order.update(process_comments: last_payment.try(:payment_method).try(:name)) if last_payment

    # Send each notification independently. A failure in one (e.g. a
    # transient template-lookup error or SMTP hiccup) shouldn't poison the
    # entire job and trigger Sidekiq's retry storm — we'd rather log it and
    # let the other email go through.
    [::AdminMailer, ::UserMailer].each do |mailer|
      begin
        mailer.update_to_paid_email(user, order).deliver_now
      rescue => e
        Rails.logger.error("[SendUnpaidToPaidEmailsWorker] #{mailer} failed for order #{order.id}: #{e.class}: #{e.message}")
      end
    end
  end
end
