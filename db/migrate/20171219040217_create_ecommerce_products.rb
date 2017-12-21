class CreateEcommerceProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_products do |t|
      t.string :name
      t.text :description
      t.string :image
      t.integer :price_cents

      t.timestamps
    end
  end
end
