module Ecommerce
  class Cart < ApplicationRecord
    belongs_to :user
    has_many :cart_items

    def add_cart_items(item_params)
      CartItem.create(user_id: current_user, product: item_params[:product_id])
    end

  end
end
