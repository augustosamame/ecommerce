class CreateEcommerceShoppingVideoOverlays < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_shopping_video_overlays do |t|
      t.references :shopping_video, index: { name: 'index_esc_video_overlays_on_shopping_video_id' }
      t.references :product, null: true, index: { name: 'index_esc_video_overlays_on_product_id' }
      t.references :category, null: true, index: { name: 'index_esc_video_overlays_on_category_id' }
      t.integer :overlay_type, default: 0
      t.integer :start_time
      t.integer :end_time
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
