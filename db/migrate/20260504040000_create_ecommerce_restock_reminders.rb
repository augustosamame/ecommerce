class CreateEcommerceRestockReminders < ActiveRecord::Migration[7.0]
  def change
    create_table :ecommerce_restock_reminders do |t|
      t.bigint   :user_id, null: false
      t.bigint   :product_id, null: false
      t.bigint   :order_id
      t.bigint   :order_item_id
      t.integer  :quantity, null: false
      t.integer  :days_to_restock, null: false
      t.integer  :status, null: false, default: 0
      t.datetime :fires_at, null: false
      t.datetime :sent_at
      t.timestamps
    end

    add_index :ecommerce_restock_reminders, [:user_id, :product_id, :status],
              name: "idx_restock_reminders_on_user_product_status"
    add_index :ecommerce_restock_reminders, :fires_at
    add_index :ecommerce_restock_reminders, :order_id
  end
end
