class CreateEcommerceCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_categories do |t|
      t.string :name
      t.string :image
      t.integer :status
      t.boolean :popular
      t.boolean :popular_homepage
      t.string :image_popular_homepage

      t.timestamps
    end
  end
end
