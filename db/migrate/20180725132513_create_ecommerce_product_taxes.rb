class CreateEcommerceProductTaxes < ActiveRecord::Migration[5.2]
  def change
    create_table :ecommerce_product_taxes do |t|
      t.references :product
      t.references :tax
      t.float :tax_amount

      t.timestamps
    end
  end
end
