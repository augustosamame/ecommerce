module Ecommerce
  class Slider < ApplicationRecord

    validates :slider_image,       presence: true

    enum status: {active: 0, inactive: 1}

    mount_uploader :slider_image, Ecommerce::SliderImageUploader

    # slider_view is free text in the backoffice ("Desktop" / "DESKTOP" both exist)
    scope :for_view, ->(view) { where("upper(slider_view) = ?", view.to_s.upcase).order(:slider_order, :id) }

    def video?
      slider_image.url.to_s.downcase.end_with?(".mp4", ".webm", ".mov")
    end

  end
end
