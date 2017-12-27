module Ecommerce
class Property < ApplicationRecord

  has_many :product_properties
  has_many :products,          :through => :product_properties

  has_many :product_sku_properties
  has_many :product_skus,          :through => :product_sku_properties

  validates :identifing_name,    presence: true, length: { maximum: 250 }
  validates :display_name,       presence: true, length: { maximum: 165 }
  # active is default true at the DB level

  scope :visible, -> {where(active: true)}

  def full_name
    "#{display_name}: (#{identifing_name})"
  end
  
  def display_active
    active? ? 'True' : 'False'
  end

end
end
