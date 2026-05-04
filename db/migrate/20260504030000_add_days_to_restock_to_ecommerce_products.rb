class AddDaysToRestockToEcommerceProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :ecommerce_products, :days_to_restock, :integer
  end
end
