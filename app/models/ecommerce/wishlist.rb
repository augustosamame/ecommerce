module Ecommerce
  class Wishlist < ApplicationRecord
    belongs_to :user, optional: true
    has_many :wishlist_items

    enum status: {active: 1, closed: 2}

    def add_wishlist_items(item_params)
      WishlistItem.create(user_id: current_user, product: item_params[:product_id])
    end

  end
end
