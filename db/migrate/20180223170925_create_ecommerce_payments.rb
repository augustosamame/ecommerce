# This migration comes from ecommerce (originally 20171220160448)
class CreateEcommercePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_payments do |t|
      t.references :user
      t.references :order
      t.references :payment_method
      t.integer :payment_request_id
      t.string :processor_transaction_id
      t.string :processor_token
      t.integer :amount_cents
      t.datetime :date
      t.text :comment
      t.integer :status

      t.timestamps
    end
    add_foreign_key :ecommerce_payments, :users, column: :user_id
    add_foreign_key :ecommerce_payments, :users, column: :order_id
    add_foreign_key :ecommerce_payments, :users, column: :payment_method_id
  end
end
