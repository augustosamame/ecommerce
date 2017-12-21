class CreateEcommerceAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_addresses do |t|
      t.references :user
      t.string :name
      t.string :street
      t.string :street2
      t.string :state
      t.string :city
      t.integer :address_type
      t.integer :shipping_or_billing
      t.integer :status

      t.timestamps
    end
    add_foreign_key :ecommerce_addresses, :users, column: :user_id
  end
end
