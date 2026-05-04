class SendRestockReminderWorker
  include Sidekiq::Worker

  # An order in any of these states means the user never effectively received
  # the product (or got a refund), so the restock reminder is no longer
  # relevant and the reminder is marked cancelled instead of sent.
  CANCELLING_ORDER_STAGES         = %w[stage_void].freeze
  CANCELLING_ORDER_STATUSES       = %w[void].freeze
  CANCELLING_ORDER_PAYMENT_STATES = %w[refunded payment_void].freeze

  def perform(reminder_id)
    reminder = Ecommerce::RestockReminder.find_by(id: reminder_id)
    return unless reminder
    return unless reminder.pending?

    user    = reminder.user
    product = reminder.product
    return unless user && product

    if order_voided_or_refunded?(reminder.order)
      reminder.update(status: :cancelled)
      return
    end

    return if user.expo_push_token.blank?

    locale = locale_for(user)
    title, body = I18n.with_locale(locale) do
      [
        I18n.t("ecommerce.workers.send_restock_reminder.title"),
        I18n.t("ecommerce.workers.send_restock_reminder.body", product: product.name)
      ]
    end

    ExpoPush.new.send_notification({
      user_id: user.id,
      title:   title,
      body:    body,
      data: {
        type:         "product",
        productId:    product.id,
        reminderType: "restock",
        reminderId:   reminder.id
      }
    })

    reminder.update(status: :sent, sent_at: Time.current)
  end

  private

  def order_voided_or_refunded?(order)
    return false unless order
    CANCELLING_ORDER_STAGES.include?(order.stage.to_s) ||
      CANCELLING_ORDER_STATUSES.include?(order.status.to_s) ||
      CANCELLING_ORDER_PAYMENT_STATES.include?(order.payment_status.to_s)
  end

  # No per-user locale field exists yet; fall back to the configured default
  # (es-PE in production). When/if `User#locale` is added, return that here
  # and the existing translation keys will pick it up.
  def locale_for(_user)
    I18n.default_locale
  end
end
