module Ecommerce
  class Slider < ApplicationRecord

    validates :slider_image,       presence: true

    enum status: {active: 0, inactive: 1}

    mount_uploader :slider_image, Ecommerce::SliderImageUploader

  end
end
