class CreateEcommerceUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :role
      t.string :address
      t.string :avatar
      t.string :doc_id
      t.integer :status

      t.timestamps
    end
  end
end
