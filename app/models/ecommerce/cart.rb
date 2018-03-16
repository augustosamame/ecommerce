module Ecommerce
  class Cart < ApplicationRecord
    belongs_to :user, optional: true
    has_one :order
    has_many :cart_items

    enum status: {active: 1, closed: 2}

    def add_cart_items(item_params)
      CartItem.create(user_id: current_user, product: item_params[:product_id])
    end

    def get_totals
      tot_acum = 0
      qty_items = 0
      self.cart_items.each do |item|
        tot_acum += item.line_total
        qty_items += item.quantity
      end
      return {tot_acum: tot_acum, tot_qty: qty_items}
    end

  end
end
