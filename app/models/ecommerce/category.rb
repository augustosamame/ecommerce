module Ecommerce
  class Category < ApplicationRecord
    has_many :products

    mount_uploader :image_popular_homepage, Ecommerce::CategoryHomeImageUploader
  end
end
