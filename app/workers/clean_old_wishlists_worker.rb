class CleanOldWishlistsWorker
  include Sidekiq::Worker
  
  def perform
    # Find and delete wishlists older than 6 months
    cutoff_date = 6.months.ago
    
    # Get count before deletion for logging
    old_wishlists_count = Ecommerce::Wishlist.where("created_at < ?", cutoff_date).count
    
    # Delete old wishlists - this will also delete associated wishlist_items due to dependent: :destroy
    deleted_count = Ecommerce::Wishlist.where("created_at < ?", cutoff_date).delete_all
    
    # Log the results
    Rails.logger.info("CleanOldWishlistsWorker: Deleted #{deleted_count} wishlists older than #{cutoff_date}")
    
    # Return the count for testing purposes
    deleted_count
  end
end
