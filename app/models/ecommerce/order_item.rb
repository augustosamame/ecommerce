module Ecommerce
  class OrderItem < ApplicationRecord
    belongs_to :order
    belongs_to :product

    monetize :price_cents, with_model_currency: :currency

    enum status: {active: 0, inactive: 1, void: 2 }

    before_create :stamp_usd_equivalent

    def line_total(current_user)
      self.quantity * (self.price)
    end

    private

    # Pre-compute USD equivalent of the line price, using the parent order's
    # exchange_rate so all line items resolve against the same FX as the order.
    # If the order has no rate yet, fall back to the live Control value.
    def stamp_usd_equivalent
      rate = self.order.try(:exchange_rate) ||
             (Ecommerce::Control.get_control_value("exchange_rate").to_d rescue nil)
      rate = BigDecimal("3.8") if rate.nil? || rate <= 0
      self.exchange_rate ||= rate

      cur = (self.currency || "usd").to_s.downcase
      effective_rate = self.exchange_rate
      self.price_usd_cents = if self.price_cents.nil?
                               nil
                             elsif cur == "usd"
                               self.price_cents.to_i
                             elsif effective_rate && effective_rate > 0
                               (self.price_cents.to_d / effective_rate).round.to_i
                             end
    end
  end
end
