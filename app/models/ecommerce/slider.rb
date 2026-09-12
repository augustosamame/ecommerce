module Ecommerce
  class Slider < ApplicationRecord

    validates :slider_image,       presence: true

    enum status: {active: 0, inactive: 1}

    mount_uploader :slider_image, Ecommerce::SliderImageUploader

    EDITORIAL_FIELDS = %w[pre_header title description cta1_text cta2_text].freeze

    # slider_view is free text in the backoffice ("Desktop" / "DESKTOP" both exist)
    scope :for_view, ->(view) { where("upper(slider_view) = ?", view.to_s.upcase).order(:slider_order, :id) }

    def video?
      slider_image.url.to_s.downcase.end_with?(".mp4", ".webm", ".mov")
    end

    # Localised editorial field, falling back to the other language.
    def localized(field, locale)
      primary = locale.to_s.start_with?("en") ? "#{field}_en" : "#{field}_es"
      secondary = primary.end_with?("_en") ? "#{field}_es" : "#{field}_en"
      self[primary].presence || self[secondary].presence
    end

    # True when any copy is set in either language: the storefront then
    # renders the split (copy + square media) layout instead of media-only.
    def editorial?
      EDITORIAL_FIELDS.any? { |f| self["#{f}_es"].present? || self["#{f}_en"].present? }
    end

  end
end
