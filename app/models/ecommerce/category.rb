module Ecommerce
  class Category < ApplicationRecord
    #has_many :products, inverse_of: :category, dependent: :restrict_with_error

    mount_uploader :image, Ecommerce::CategoryImageUploader
    mount_uploader :image_popular_homepage, Ecommerce::CategoryHomeImageUploader

    enum status: {active: 0, inactive: 1}
    enum category_type: {primary: 0, secondary: 1}
  end
end
