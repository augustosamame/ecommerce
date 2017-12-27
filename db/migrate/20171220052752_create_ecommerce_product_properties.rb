class CreateEcommerceProductProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :ecommerce_product_properties do |t|
      t.references :product
      t.references :property
      t.integer     :position
      t.string      :description, :null => false

      t.timestamps
    end
    add_foreign_key :ecommerce_product_properties, :ecommerce_products, column: :product_id
    add_foreign_key :ecommerce_product_properties, :ecommerce_properties, column: :property_id
  end
end
