class CreateEcommerceCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_categories do |t|
      t.string :name
      t.string :image
      t.integer :status

      t.timestamps
    end
  end
end
