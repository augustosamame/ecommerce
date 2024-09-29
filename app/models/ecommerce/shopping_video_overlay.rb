module Ecommerce
  class ShoppingVideoOverlay < ApplicationRecord
    belongs_to :shopping_video, class_name: 'Ecommerce::ShoppingVideo'
    belongs_to :product, class_name: 'Ecommerce::Product'

    enum status: { active: 0, inactive: 1 }

    validates :start_time, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :end_time, presence: true, numericality: { greater_than: :start_time }
  end
end
