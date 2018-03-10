module Ecommerce
  class Category < ApplicationRecord
    #has_many :products, inverse_of: :category, dependent: :restrict_with_error

    mount_uploader :image, Ecommerce::CategoryImageUploader
    mount_uploader :image_popular_homepage, Ecommerce::CategoryHomeImageUploader

    enum status: {active: 0, inactive: 1}
    enum category_type: {primary: 0, secondary: 1}

    def cat_group_for_select
      case self.category_type
      when "primary"
        return ["primary"]
      when "secondary"
        return ["secondary"]
      end

    end
  end
end
