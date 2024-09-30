class CreateEcommerceShoppingVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_shopping_videos do |t|
      t.string :title, null: false
      t.string :description
      t.string :video, null: false
      t.string :thumbnail, null: false
      t.integer :priority, default: 0
      t.string :processing_status, default: 'pending'
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
