class CreateEcommerceProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_products do |t|
      t.references :category
      t.references :brand
      t.references :supplier
      t.string :name, :null => false
      t.string :short_description, default: ""
      t.text :description, default: ""
      t.string :image
      t.string :permalink, :null => false
      t.integer :price_cents, :default => 0
      t.integer :discounted_price_cents, :default => 0
      t.string  :meta_keywords
      t.string  :meta_description
      t.boolean :stockable, default: true
      t.boolean :home_featured, default: false
      t.boolean :category_featured, default: false
      t.datetime :available_at
      t.datetime :deleted_at

      t.timestamps
    end
    add_foreign_key :ecommerce_products, :ecommerce_categories, column: :category_id
    add_foreign_key :ecommerce_products, :ecommerce_brands, column: :brand_id
    add_index :ecommerce_products, :name
    add_index :ecommerce_products, :permalink,   :unique => true

  end
end
