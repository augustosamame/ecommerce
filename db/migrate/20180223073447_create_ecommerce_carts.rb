class CreateEcommerceCarts < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_carts do |t|
      t.references :user, optional: true
      t.integer :status

      t.timestamps
    end
    add_foreign_key :ecommerce_carts, :users, column: :user_id
  end
end
