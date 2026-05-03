class CreateEcommerceProductMedia < ActiveRecord::Migration[7.0]
  # Adds support for multiple images and videos per product. The single
  # `ecommerce_products.image` column stays as the primary thumbnail (backward
  # compatibility); additional gallery items live in this table so they can be
  # ordered and freely mixed (image / video).
  def change
    create_table :ecommerce_product_media do |t|
      t.references :product, null: false, foreign_key: { to_table: :ecommerce_products }
      t.string :media_type, null: false # "image" or "video"
      t.string :file
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :ecommerce_product_media, [:product_id, :position],
              name: 'index_ecommerce_product_media_on_product_and_position'
  end
end
