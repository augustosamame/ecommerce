class CreateEcommerceBackofficeProductSkus < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_backoffice_product_skus do |t|
      t.references :product
      t.references :product_variant
      t.string :sku
      t.integer :price_cents
      t.integer :status

      t.timestamps
    end
    add_foreign_key :ecommerce_backoffice_product_skus, :ecommerce_backoffice_products, column: :product_id
    add_foreign_key :ecommerce_backoffice_product_skus, :ecommerce_backoffice_product_variants, column: :product_variant_id
  end
end
