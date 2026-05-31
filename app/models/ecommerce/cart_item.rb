module Ecommerce

  class CartItem < ApplicationRecord
    belongs_to :cart
    belongs_to :product

    # Marker for the Free Product marketing feature: when this item's
    # product matches Ecommerce::FreeProduct.protected_product_id we charge
    # 1 cent regardless of the product's normal price. Keep the override
    # currency = Order's denomination ('usd'), since the order/cart/order_item
    # pipeline already denominates everything in USD and converts to PEN at
    # display time via cart_session_price / exchange_rate.
    FREE_PRODUCT_OVERRIDE = Money.new(1, 'usd')

    def unit_price(current_user)
      return FREE_PRODUCT_OVERRIDE if free_product?
      product&.current_price(current_user) || 0
    end

    def line_total(current_user)
      (self.quantity || 0) * unit_price(current_user)
    end

    # Whether this cart item is the protected Free Product line for the
    # current request's platform (web vs app — see Current.platform). When
    # the singleton is configured for the other platform only, this returns
    # false and the line behaves like any normal product.
    def free_product?
      Ecommerce::FreeProduct.protected_product_id_for(Current.platform) == product_id
    end

  end

end
