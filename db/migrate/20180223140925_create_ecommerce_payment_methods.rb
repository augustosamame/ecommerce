# This migration comes from ecommerce (originally 20171220160448)
class CreateEcommercePaymentMethods < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_payment_methods do |t|
      t.string :name
      t.integer :status

      t.timestamps
    end
  end
end
