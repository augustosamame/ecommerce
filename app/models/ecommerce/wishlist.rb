module Ecommerce
  class Wishlist < ApplicationRecord
    belongs_to :user, optional: true
    has_many :wishlist_items, dependent: :destroy

    enum status: {active: 1, closed: 2}

    def add_wishlist_items(item_params)
      WishlistItem.create(user_id: current_user, product: item_params[:product_id])
    end

    # Clean up wishlists older than 6 months
    # Returns the number of wishlists deleted
    # Usage: Ecommerce::Wishlist.clean_old_wishlists
    def self.clean_old_wishlists
      cutoff_date = 6.months.ago
      
      # Get count before deletion for logging
      old_wishlists_count = Ecommerce::Wishlist.where("created_at < ?", cutoff_date).count
      
      # Delete old wishlists - this will also delete associated wishlist_items due to dependent: :destroy
      deleted_count = Ecommerce::Wishlist.where("created_at < ?", cutoff_date).delete_all
      
      # Log the results
      Rails.logger.info("Wishlist.clean_old_wishlists: Deleted #{deleted_count} wishlists older than #{cutoff_date}")
      
      # Return the count for reporting
      deleted_count
    end

  end
end
