module Ecommerce
  class Cart < ApplicationRecord
    belongs_to :user, optional: true
    has_one :order
    has_many :cart_items

    enum status: {active: 1, closed: 2}

    def add_cart_items(item_params)
      CartItem.create(user_id: current_user, product: item_params[:product_id])
    end

  end
end
