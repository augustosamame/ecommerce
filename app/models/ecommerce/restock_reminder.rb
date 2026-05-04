module Ecommerce
  class RestockReminder < ApplicationRecord
    self.table_name = "ecommerce_restock_reminders"

    belongs_to :user
    belongs_to :product, class_name: "Ecommerce::Product"
    belongs_to :order,   class_name: "Ecommerce::Order", optional: true

    enum status: { pending: 0, sent: 1, cancelled: 2 }

    scope :for_user_product, ->(user_id, product_id) {
      where(user_id: user_id, product_id: product_id)
    }
  end
end
