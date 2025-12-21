module Ecommerce
  class ComboComponent < ApplicationRecord
    belongs_to :product
    belongs_to :component_product, class_name: 'Ecommerce::Product'

    validates :quantity, presence: true, numericality: { greater_than: 0 }
    validates :component_product_id, presence: true
    validates :component_product_id, uniqueness: { scope: :product_id, message: "already added as a component" }
  end
end
