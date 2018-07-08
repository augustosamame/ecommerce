class AddEcommerceStatusToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_products, :status, :integer, default: 0
    add_index :ecommerce_products, :status
  end
end
