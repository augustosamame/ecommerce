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

    # Cart rows that were injected for free by a combo with inject_product_two.
    # Same-product combos (e.g. "Buy 2 Nerio, get 1 free") keep the bonus on a
    # separate row: the oldest row is the customer's trigger and any later row
    # is the bonus. For different-product combos every row of product_id_2 is
    # a bonus. Same convention as Api::V1::CartsController.
    def combo_bonus_items(combo)
      return [] if combo.product_id_2.blank?
      rows = cart_items.where(product_id: combo.product_id_2).order(:id).to_a
      combo.product_id_1 == combo.product_id_2 ? rows.drop(1) : rows
    end

    def injecting_combo_for(product_id)
      Ecommerce::ComboDiscount.where(status: "active", product_id_1: product_id, inject_product_two: true).order(:id).first
    end

    # Call BEFORE destroying the trigger row of `product_id`: in a same-product
    # combo the bonus would otherwise become the oldest row and be mistaken
    # for the customer's own.
    # Drops rows whose product was deactivated after it was added (and any
    # combo bonus they injected). Returns the removed product names.
    # Free Product coupon lines are left alone: ensure_free_product_in_cart
    # would re-add them on the next request.
    def remove_inactive_items
      cart_items.includes(:product).select { |cart_item| cart_item.product&.inactive? && !cart_item.free_product_line? }.map do |cart_item|
        remove_combo_bonus(cart_item.product_id)
        cart_item.destroy
        cart_item.product.name
      end
    end

    def remove_combo_bonus(product_id)
      combo = injecting_combo_for(product_id)
      combo_bonus_items(combo).each(&:destroy) if combo
    end

    # Brings the injected bonus in line with the trigger quantity currently in
    # the cart: one bonus row, updated in place, removed when the threshold is
    # no longer met. Call after any change to a row of `product_id`.
    # Returns true when a bonus is in the cart afterwards.
    def sync_combo_bonus(product_id)
      combo = injecting_combo_for(product_id)
      return false unless combo && combo.product_id_2.present? && combo.qty_product_1.to_i > 0

      trigger_qty =
        if combo.product_id_1 == combo.product_id_2
          cart_items.where(product_id: product_id).order(:id).first&.quantity.to_i
        else
          cart_items.where(product_id: product_id).sum(:quantity)
        end
      target_qty = combo.qty_product_2.to_i * (trigger_qty / combo.qty_product_1)

      bonus_row, *extra_rows = combo_bonus_items(combo)
      extra_rows.each(&:destroy)

      if target_qty <= 0
        bonus_row&.destroy
        false
      elsif bonus_row
        bonus_row.update(quantity: target_qty) unless bonus_row.quantity == target_qty
        true
      else
        cart_items.create(product_id: combo.product_id_2, quantity: target_qty)
        true
      end
    end

    def self.send_email_to_all_abandoned_carts
      if Ecommerce::Control.find_by(name: 'send_abandoned_cart_email_active')&.boolean_value == true
        Ecommerce::Cart.where(status: 'active', abandoned_email_sent: false).where("ecommerce_carts.created_at < ? AND ecommerce_carts.created_at > ?", Time.now - 24.hours, Time.now - 48.hours).where.not(user_id: nil).distinct.each do |cart|
          unless cart.cart_items.empty?
            coupon = Ecommerce::Coupon.one_time_coupon(cart.user.id)
            SendAbandonedCartEmailWorker.perform_async(cart.id, coupon.id)
            SendAbandonedCartPushWorker.perform_async(cart.id, coupon.id)
          end
        end
      end
    end

    # Clean up carts older than 3 months
    # Returns the number of carts deleted
    # Usage: Ecommerce::Cart.clean_old_carts
    def self.clean_old_carts
      cutoff_date = 3.months.ago
      
      # Get count before deletion for logging
      old_carts_count = Ecommerce::Cart.where("created_at < ?", cutoff_date).count
      
      # Delete old carts - this will also delete associated cart_items due to dependent: :destroy
      deleted_count = Ecommerce::Cart.where("created_at < ?", cutoff_date).delete_all
      
      # Log the results
      Rails.logger.info("Cart.clean_old_carts: Deleted #{deleted_count} carts older than #{cutoff_date}")
      
      # Return the count for reporting
      deleted_count
    end
  end
end
