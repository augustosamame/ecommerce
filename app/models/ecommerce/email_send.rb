module Ecommerce
  # One row per email *delivered through ActionMailer*. Created by the mailer
  # base class via `track_email(...)` and stamped with a unique `token`. The
  # tracking interceptor rewrites links in the rendered HTML to redirect via
  # /r/:token, so each click can be attributed back to this row.
  class EmailSend < ApplicationRecord
    self.table_name = "ecommerce_email_sends"

    CATEGORIES = %w[bulk operational].freeze

    belongs_to :user, optional: true
    belongs_to :subject, polymorphic: true, optional: true
    has_many :email_clicks, class_name: "Ecommerce::EmailClick", dependent: :destroy

    validates :category, inclusion: { in: CATEGORIES }
    validates :token,    presence: true, uniqueness: true

    before_validation :ensure_token

    scope :bulk,        -> { where(category: "bulk") }
    scope :operational, -> { where(category: "operational") }
    scope :sent_between, ->(from, to) {
      rel = all
      rel = rel.where("sent_at >= ?", from) if from
      rel = rel.where("sent_at <= ?", to)   if to
      rel
    }

    def click_through_rate
      return 0.0 if opens_count.to_i == 0
      ((clicks_count.to_f / opens_count) * 100).round(2)
    end

    private

    def ensure_token
      self.token ||= SecureRandom.hex(16)
    end
  end
end
