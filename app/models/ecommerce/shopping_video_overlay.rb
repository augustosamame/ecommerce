module Ecommerce
  class ShoppingVideoOverlay < ApplicationRecord
    belongs_to :shopping_video, class_name: 'Ecommerce::ShoppingVideo'
    belongs_to :product, class_name: 'Ecommerce::Product', optional: true
    belongs_to :category, class_name: 'Ecommerce::Category', optional: true

    enum status: { active: 0, inactive: 1 }
    enum overlay_type: { product: 0, category: 1 }

    validates :start_time, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :end_time, presence: true, numericality: { greater_than: :start_time }
    validates :overlay_type, presence: true
    validate :product_or_category_present

    before_save :set_overlay_type

    def set_overlay_type
      if product_id.present?
        self.overlay_type = :product
      elsif category_id.present?
        self.overlay_type = :category
      end
    end

    private

    def product_or_category_present
      if product_id.blank? && category_id.blank?
        errors.add(:base, "Either product_id or category_id must be present")
      elsif product_id.present? && category_id.present?
        errors.add(:base, "Only one of product_id or category_id must be present")
      end
    end
  
  end
end
