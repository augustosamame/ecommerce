module Ecommerce
class ProductSkuProperty < ApplicationRecord

  belongs_to :product_sku
  belongs_to :property

  validates :product_sku_id, uniqueness: { scope: :property_id }
  validates :property_id,  presence: true
  validates :description,  presence: true,       length: { maximum: 255 }


  # name of the property
  #
  # @param [none]
  # @return [String]
  def property_name
    property.display_name
  end
end
end
