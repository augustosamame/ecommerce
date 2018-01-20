class CreateEcommerceCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_categories do |t|
      t.string :name, :null => false
      t.integer :parent_id #0 if root category
      t.string :image
      t.integer :status
      t.boolean :main_menu, default: "false"
      t.boolean :popular, default: "false"
      t.boolean :popular_homepage, default: "false"
      t.string :image_popular_homepage
      t.decimal :homepage_cat_image_width
      t.decimal :homepage_cat_image_height

      t.timestamps
    end

    add_index :ecommerce_categories, :parent_id
  end
end
