module Ecommerce
  # A single piece of gallery media (image or video) attached to a product.
  # Sits next to the existing `Product#image` (which remains the primary
  # thumbnail) and lets us render an ordered, mixed media gallery on the
  # storefront and mobile product pages.
  class ProductMedia < ApplicationRecord
    self.table_name = 'ecommerce_product_media'

    belongs_to :product, class_name: 'Ecommerce::Product'

    mount_uploader :file, Ecommerce::ProductMediaUploader

    MEDIA_TYPES = %w[image video].freeze

    validates :media_type, inclusion: { in: MEDIA_TYPES }

    scope :images, -> { where(media_type: 'image') }
    scope :videos, -> { where(media_type: 'video') }

    default_scope -> { order(:position, :id) }

    def image?
      media_type == 'image'
    end

    def video?
      media_type == 'video'
    end
  end
end
