module Ecommerce

  class CartItem < ApplicationRecord
    belongs_to :cart
    belongs_to :product

    # Override applied when this cart line is the product attached to an
    # active `free_product` coupon for the current platform. Stored in USD
    # cents to match how the order/cart/order_item pipeline denominates
    # everything; PEN display happens later via cart_session_price.
    FREE_PRODUCT_OVERRIDE = Money.new(1, 'usd')

    def unit_price(current_user)
      return FREE_PRODUCT_OVERRIDE if free_product_line?
      product&.current_price(current_user) || 0
    end

    def line_total(current_user)
      (self.quantity || 0) * unit_price(current_user)
    end

    # True when this cart_item's product is the one configured on an active
    # always-on `free_product` coupon for the current request's platform
    # (Current.platform). See Ecommerce::Coupon.active_free_product_for.
    def free_product_line?
      coupon = Ecommerce::Coupon.active_free_product_for(Current.platform)
      coupon && coupon.free_product_id == product_id
    end

  end

end
