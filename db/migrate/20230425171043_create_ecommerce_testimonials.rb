class CreateEcommerceTestimonials < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_testimonials do |t|
      t.string :user_fullname, null: false
      t.string :user_title, null: false
      t.string :product_name, null: false
      t.string :video, null: false
      t.string :thumbnail, null: false
      t.integer :status, default: 0
      t.integer :priority, default: 1

      t.timestamps
    end
  end
end
