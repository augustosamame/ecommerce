module Ecommerce
  class Category < ApplicationRecord
    has_many :products, inverse_of: :category, dependent: :restrict_with_error

    mount_uploader :image, Ecommerce::CategoryImageUploader
    mount_uploader :image_popular_homepage, Ecommerce::CategoryHomeImageUploader
  end
end
