module Ecommerce
  class AlwaysOnBanner < ApplicationRecord
    enum status: { active: 0, inactive: 1 }

    scope :active, -> { where(status: statuses[:active]) }

    validates :message_en, presence: true
    validates :message_es, presence: true
    validate :at_least_one_platform_enabled
    validate :only_one_active_banner

    def web?
      web_enabled?
    end

    def app?
      app_enabled?
    end

    private

    def at_least_one_platform_enabled
      return if web_enabled? || app_enabled?
      errors.add(:base, 'Enable the banner on web, app, or both.')
    end

    def only_one_active_banner
      return unless active?
      existing = self.class.active.where.not(id: id).first
      errors.add(:status, 'There is already an active Always On Banner.') if existing
    end
  end
end
