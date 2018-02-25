# This migration comes from ecommerce (originally 20171220160448)
class CreateEcommerceOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_orders do |t|
      t.references :user
      t.integer :amount_cents
      t.integer :stage
      t.integer :shipping_address_id
      t.integer :billing_address_id
      t.integer :coupon_id
      t.integer :payment_status
      t.integer :status
      t.integer :stage
      t.text :customer_comments
      t.text :process_comments
      t.text :delivery_comments

      t.timestamps
    end
    add_foreign_key :ecommerce_orders, :users, column: :user_id
  end
end
