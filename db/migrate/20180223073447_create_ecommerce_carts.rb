class CreateEcommerceCarts < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_carts do |t|
      t.references :user
      t.integer :status

      t.timestamps
    end
  end
end
