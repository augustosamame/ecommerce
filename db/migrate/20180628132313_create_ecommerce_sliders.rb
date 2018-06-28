class CreateEcommerceSliders < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_sliders do |t|
      t.string :slider_name
      t.string :slider_text
      t.text :slider_image
      t.string :slider_view
      t.integer :slider_order, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
