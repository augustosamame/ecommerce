class AddAccountingCodeFamilyToEcommerceProducts < ActiveRecord::Migration[7.0]
  def change
    add_reference :ecommerce_products, :accounting_code_family, null: true, index: true
    add_foreign_key :ecommerce_products, :ecommerce_accounting_code_families, column: :accounting_code_family_id
  end
end
