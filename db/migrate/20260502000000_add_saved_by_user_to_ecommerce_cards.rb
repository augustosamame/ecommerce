class AddSavedByUserToEcommerceCards < ActiveRecord::Migration[7.0]
  def change
    add_column :ecommerce_cards, :saved_by_user, :boolean, default: false, null: false
    add_index :ecommerce_cards, [:user_id, :saved_by_user, :status]
  end
end
