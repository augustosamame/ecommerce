module Ecommerce
  class DiscountGroup < ApplicationRecord
    enum status: { active: 0, inactive: 1 }

    has_many :products, class_name: "Ecommerce::Product", foreign_key: :discount_group_id, dependent: :nullify

    validates :name, presence: true, uniqueness: true
    validates :discount_percentage, numericality: { greater_than_or_equal_to: 0, less_than: 100 }

    # Bulk-applies (or removes) a discount on every member product — the exact
    # equivalent of editing each product's discounted price by hand in the
    # backoffice, just in one pass:
    #   active: true  → discounted_price = price × (1 − percentage/100)
    #   active: false → discounted_price = price ("no discount" is stored as
    #                   discounted == price; see Product#discounted?)
    # usd_discounted_price_cents is kept in sync, mirroring the backoffice
    # ProductsController convention. Uses product.update so the same callbacks
    # fire as a manual one-by-one edit.
    #
    # Returns [applied_count, [error_messages]].
    def apply_discount!(percentage:, active:)
      pct = BigDecimal(percentage.to_s.presence || "0")
      if active && (pct <= 0 || pct >= 100)
        raise ArgumentError, "El porcentaje de descuento debe estar entre 0 y 99.99"
      end

      applied = 0
      failed = []
      products.find_each do |product|
        if product.price_cents.blank?
          failed << "#{product.permalink.presence || product.id}: sin precio"
          next
        end
        new_discounted = if active
                           (BigDecimal(product.price_cents.to_s) * (1 - pct / 100)).round
                         else
                           product.price_cents
                         end
        if product.update(discounted_price_cents: new_discounted, usd_discounted_price_cents: new_discounted)
          applied += 1
        else
          failed << "#{product.permalink.presence || product.id}: #{product.errors.full_messages.to_sentence}"
        end
      end

      update!(discount_percentage: pct, discount_active: active, last_applied_at: Time.current)
      [applied, failed]
    end
  end
end
