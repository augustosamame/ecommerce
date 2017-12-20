class CreateEcommerceProductSkuProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_product_sku_properties do |t|
      t.references :product_sku, index: {name: "index_ecommerce_back_prod_sku_prop_on_prod_sku_id"}
      t.references :product_variant, index: {name: "index_ecommerce_back_prod_sku_prop_on_prod_variant_id"}
      t.string :value
      t.integer :status

      t.timestamps
    end
    add_foreign_key :ecommerce_product_sku_properties, :ecommerce_product_skus, column: :product_sku_id
    add_foreign_key :ecommerce_product_sku_properties, :ecommerce_product_variants, column: :product_variant_id
  end
end
