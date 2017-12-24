module Ecommerce
  class Product < ApplicationRecord
    belongs_to :category

    mount_uploader :image, Ecommerce::ProductImageUploader
  end
end
