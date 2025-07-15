class CleanOldCartsWorker
  include Sidekiq::Worker
  
  def perform
    # Find and delete carts older than 3 months
    cutoff_date = 3.months.ago
    
    # Get count before deletion for logging
    old_carts_count = Ecommerce::Cart.where("created_at < ?", cutoff_date).count
    
    # Delete old carts - this will also delete associated cart_items due to dependent: :destroy
    deleted_count = Ecommerce::Cart.where("created_at < ?", cutoff_date).delete_all
    
    # Log the results
    Rails.logger.info("CleanOldCartsWorker: Deleted #{deleted_count} carts older than #{cutoff_date}")
    
    # Return the count for testing purposes
    deleted_count
  end
end
