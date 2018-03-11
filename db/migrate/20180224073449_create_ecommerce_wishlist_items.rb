class CreateEcommerceWishlistItems < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_wishlist_items do |t|
      t.references :wishlist
      t.integer :product_id
      t.integer :quantity
      t.integer :status

      t.timestamps
    end
  end
end
