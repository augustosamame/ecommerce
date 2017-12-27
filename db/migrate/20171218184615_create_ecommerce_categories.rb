class CreateEcommerceCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_categories do |t|
      t.string :name, :null => false
      t.integer :parent_id
      t.string :image
      t.integer :status
      t.boolean :popular
      t.boolean :popular_homepage
      t.string :image_popular_homepage
      t.decimal :homepage_cat_image_width
      t.decimal :homepage_cat_image_height

      t.timestamps
    end

    add_index :ecommerce_categories, :parent_id
  end
end
