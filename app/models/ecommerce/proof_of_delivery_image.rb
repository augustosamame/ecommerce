module Ecommerce
  class ProofOfDeliveryImage < ApplicationRecord
    belongs_to :user
    belongs_to :order, class_name: "Ecommerce::Order"

    mount_uploader :proof_of_delivery, Ecommerce::ProofOfDeliveryImageUploader

    validates :proof_of_delivery, presence: true
    validates :user_id, presence: true
    validates :order_id, presence: true

    scope :recent, -> { order(created_at: :desc) }
    scope :for_order, ->(order_id) { where(order_id: order_id) }
  end
end