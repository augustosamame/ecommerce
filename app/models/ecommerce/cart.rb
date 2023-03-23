module Ecommerce
  class Cart < ApplicationRecord
    belongs_to :user, optional: true
    has_one :order
    has_many :cart_items, dependent: :destroy

    enum status: {active: 1, closed: 2}

    def add_cart_items(item_params)
      CartItem.create(user_id: current_user, product: item_params[:product_id])
    end

    def get_totals(current_user)
      tot_acum = 0
      qty_items = 0
      tot_acum_kgs = 0
      self.cart_items.each do |item|
        tot_acum += item.line_total(current_user)
        qty_items += item.quantity
        tot_acum_kgs += (item.try(:product).try(:weight) || 0) * item.quantity
      end
      return {tot_acum: tot_acum, tot_qty: qty_items, tot_kgs: tot_acum_kgs}
    end

    def self.send_email_to_all_abandoned_carts
      Ecommerce::Cart.where(status: 'active', abandoned_email_sent: false).where("ecommerce_carts.created_at < ? AND ecommerce_carts.created_at > ?", Time.now - 12.hours, Time.now - 24.hours).joins(:cart_items).distinct.each do |cart|
        SendAbandonedCartEmailWorker.perform_async(cart.id) unless cart.cart_items.empty?
      end
    end

  end
end
