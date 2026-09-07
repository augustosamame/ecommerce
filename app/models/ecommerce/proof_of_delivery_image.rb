module Ecommerce
  class ProofOfDeliveryImage < ApplicationRecord
    belongs_to :user
    # Optional since invoicing-platform documents (manual comprobantes and
    # guias, columns invoicing_invoice_id / invoicing_guia_id) share this
    # table; a row must belong to exactly one parent.
    belongs_to :order, class_name: "Ecommerce::Order", optional: true

    mount_uploader :proof_of_delivery, Ecommerce::ProofOfDeliveryImageUploader

    validates :proof_of_delivery, presence: true
    validates :user_id, presence: true
    validate :exactly_one_parent

    def exactly_one_parent
      parents = [order_id, invoicing_invoice_id, invoicing_guia_id].compact
      errors.add(:base, "must belong to exactly one order/comprobante/guia") unless parents.size == 1
    end

    scope :recent, -> { order(created_at: :desc) }
    scope :for_order, ->(order_id) { where(order_id: order_id) }
  end
end