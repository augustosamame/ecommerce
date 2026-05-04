module Ecommerce
  # Mixin for ActionMailer subclasses. Call `track_email(...)` inside any
  # mailer method to register that send. The tracking interceptor will then
  # rewrite links in the email body to redirect via /r/:token, recording
  # clicks against the resulting `EmailSend` row.
  #
  # Usage:
  #   def abandoned_cart_email(user, cart, coupon)
  #     @user = user; @cart = cart; @coupon = coupon
  #     track_email(category: :operational, subtype: 'abandoned_cart',
  #                 user: user, subject: cart)
  #     mail(to: user.email, subject: t('.subject'))
  #   end
  module EmailTracking
    extend ActiveSupport::Concern

    HEADER = "X-Email-Send-Token".freeze

    private

    # `category`: :bulk or :operational (string also accepted)
    # `subtype` : free-form short identifier ('abandoned_cart', 'campaign', ...)
    # `user`    : the user the email is for; nil if unknown (also pulls email/id)
    # `subject` : optional ActiveRecord object for cross-reference (Order, Cart,
    #             Campaign, ...). Stored polymorphically.
    def track_email(category:, subtype:, user: nil, subject: nil, email: nil)
      return unless Ecommerce::EmailTracking.enabled?

      record = Ecommerce::EmailSend.create!(
        token:         SecureRandom.hex(16),
        category:      category.to_s,
        subtype:       subtype.to_s,
        user_id:       user&.id,
        email:         email || user&.email,
        subject_type:  subject&.class&.base_class&.name,
        subject_id:    subject&.id,
        mailer_class:  self.class.name,
        mailer_action: action_name,
        sent_at:       Time.current
      )
      headers[HEADER] = record.token
      record
    rescue => e
      # Tracking must never break delivery. Log and continue.
      Rails.logger.warn("[EmailTracking] failed to record send: #{e.class}: #{e.message}")
      nil
    end

    class << self
      def enabled?
        return false if defined?(Rails) && Rails.env.test?
        ActiveRecord::Base.connection.table_exists?("ecommerce_email_sends")
      rescue
        false
      end
    end
  end
end
