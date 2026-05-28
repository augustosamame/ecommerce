class CreateEcommerceAccountingCodeFamilies < ActiveRecord::Migration[7.0]
  def change
    create_table :ecommerce_accounting_code_families do |t|
      t.string :accounting_code
      t.string :product_family

      t.timestamps
    end
  end
end
