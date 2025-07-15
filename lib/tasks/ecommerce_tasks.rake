namespace :ecommerce do
  desc "Clean carts older than 3 months"
  task clean_old_carts: :environment do
    puts "Starting cleanup of old carts..."
    deleted_count = CleanOldCartsWorker.new.perform
    puts "Cleanup complete. Deleted #{deleted_count} carts."
  end

  desc "Clean wishlists older than 6 months"
  task clean_old_wishlists: :environment do
    puts "Starting cleanup of old wishlists..."
    deleted_count = CleanOldWishlistsWorker.new.perform
    puts "Cleanup complete. Deleted #{deleted_count} wishlists."
  end

  desc "Clean both old carts and wishlists"
  task clean_database: :environment do
    puts "Starting database cleanup..."
    cart_count = CleanOldCartsWorker.new.perform
    wishlist_count = CleanOldWishlistsWorker.new.perform
    puts "Cleanup complete. Deleted #{cart_count} carts and #{wishlist_count} wishlists."
  end
  
  desc "Analyze and vacuum the wishlist table to reclaim space"
  task vacuum_wishlist: :environment do
    puts "Starting wishlist table maintenance..."
    
    # Get database connection
    conn = ActiveRecord::Base.connection
    
    # Get table size before vacuum
    before_size = conn.execute("SELECT pg_size_pretty(pg_total_relation_size('ecommerce_wishlists'));").first["pg_size_pretty"]
    puts "Wishlist table size before vacuum: #{before_size}"
    
    # Analyze the table to update statistics
    puts "Analyzing wishlist table..."
    conn.execute("ANALYZE ecommerce_wishlists;")
    
    # Perform a VACUUM FULL to reclaim space and rebuild the table
    puts "Performing VACUUM FULL on wishlist table (this may take a while)..."
    conn.execute("VACUUM FULL ecommerce_wishlists;")
    
    # Get table size after vacuum
    after_size = conn.execute("SELECT pg_size_pretty(pg_total_relation_size('ecommerce_wishlists'));").first["pg_size_pretty"]
    puts "Wishlist table size after vacuum: #{after_size}"
    
    puts "Wishlist table maintenance complete."
  end
end
