# This migration comes from ecommerce (originally 20171220160448)
class CreatePaymentMethods < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.integer :status

      t.timestamps
    end
  end
end
