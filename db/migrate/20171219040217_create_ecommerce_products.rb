class CreateEcommerceProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_products do |t|
      t.references :category
      t.string :name
      t.text :description
      t.string :image
      t.integer :price_cents
      t.boolean :stockable, default: true

      t.timestamps
    end
    add_foreign_key :ecommerce_products, :ecommerce_categories, column: :category_id
  end
end
