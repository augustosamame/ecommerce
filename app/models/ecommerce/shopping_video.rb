module Ecommerce
  class ShoppingVideo < ApplicationRecord
    has_many :shopping_video_overlays, dependent: :destroy
    accepts_nested_attributes_for :shopping_video_overlays, reject_if: :all_blank, allow_destroy: true

    enum status: {active: 0, inactive: 1}

    mount_uploader :video, Ecommerce::ShoppingVideoUploader
    mount_uploader :thumbnail, Ecommerce::ShoppingVideoImageUploader

    validates :title, presence: true
    validates :video, presence: true
    validates :thumbnail, presence: true

    validates :priority, uniqueness: true

  end
end
