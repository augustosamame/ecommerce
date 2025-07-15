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
      if Ecommerce::Control.find_by(name: 'send_abandoned_cart_email_active').boolean_value == true
        Ecommerce::Cart.where(status: 'active', abandoned_email_sent: false).where("ecommerce_carts.created_at < ? AND ecommerce_carts.created_at > ?", Time.now - 24.hours, Time.now - 48.hours).where.not(user_id: nil).distinct.each do |cart|
          unless cart.cart_items.empty?
            coupon = Ecommerce::Coupon.one_time_coupon(cart.user.id)
            SendAbandonedCartEmailWorker.perform_async(cart.id, coupon.id) 
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
