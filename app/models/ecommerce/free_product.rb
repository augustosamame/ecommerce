module Ecommerce
  # Singleton-style settings row for the "Free Product" marketing feature.
  # Independently toggles per platform (web / app). When a platform's flag is
  # true and `product_id` points to an Ecommerce::Product, cart logic for that
  # platform injects exactly one unit at a 1-cent price and protects it from
  # deletion / qty edits.
  class FreeProduct < ApplicationRecord
    belongs_to :product, class_name: 'Ecommerce::Product', optional: true

    PLATFORMS = %i[web app].freeze

    validate :at_least_one_platform_when_configured
    validate :product_required_when_any_platform_active

    # Returns the singleton row, creating it on first call.
    def self.current
      first || create!(web_active: false, app_active: false)
    end

    # Returns the protected product_id for the given platform when that
    # platform is active AND a product is configured. nil otherwise.
    # Single source of truth for cart guards — controllers/models call this
    # with their known platform (or Current.platform).
    def self.protected_product_id_for(platform)
      key = platform.to_s.to_sym
      return nil unless PLATFORMS.include?(key)
      row = current
      return nil unless row.product_id.present?
      active_for_platform?(row, key) ? row.product_id : nil
    end

    def self.active_for_platform?(row, key)
      key == :web ? row.web_active? : row.app_active?
    end

    def active_for?(platform)
      self.class.active_for_platform?(self, platform.to_s.to_sym)
    end

    private

    def at_least_one_platform_when_configured
      return unless product_id.present?
      return if web_active? || app_active?
      errors.add(:base, 'Select at least one platform (Web or App) for the free product.')
    end

    def product_required_when_any_platform_active
      return unless web_active? || app_active?
      errors.add(:product_id, 'must be selected when the feature is active on Web or App') if product_id.blank?
    end
  end
end
