class CreateEcommerceProductVariants < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_product_variants do |t|
      t.references :product
      t.string :variant_name

      t.timestamps
    end
    add_foreign_key :ecommerce_product_variants, :ecommerce_products, column: :product_id
  end
end
