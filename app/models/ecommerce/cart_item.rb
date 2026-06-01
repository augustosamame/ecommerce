module Ecommerce

  class CartItem < ApplicationRecord
    belongs_to :cart
    belongs_to :product

    # Override applied when this cart line is the product attached to an
    # active `free_product` coupon for the current platform. It MUST be labeled
    # in the same currency as every product price (Money.default_currency, set
    # from Ecommerce.default_currency). Otherwise summing it into the cart
    # subtotal mixes currencies and Money silently converts the other lines
    # (e.g. PEN 8.90 -> USD 2.34), corrupting the totals — or raises
    # Money::Bank::UnknownRate. The 1-cent value still renders as ~0; the cart
    # view shows it as $0.01 / S/.0.04 via the usual dollar/exchange_rate display.
    FREE_PRODUCT_OVERRIDE = Money.new(1, Money.default_currency)

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
