class CreateEcommerceWishlists < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_wishlists do |t|
      t.references :user, optional: true
      t.integer :status

      t.timestamps
    end
    add_foreign_key :ecommerce_wishlists, :users, column: :user_id
  end
end
