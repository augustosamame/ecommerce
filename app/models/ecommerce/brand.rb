module Ecommerce
  class Brand < ApplicationRecord
    has_many :products, inverse_of: :brand, dependent: :restrict_with_error

    mount_uploader :logo, Ecommerce::BrandLogoUploader
  end
end
