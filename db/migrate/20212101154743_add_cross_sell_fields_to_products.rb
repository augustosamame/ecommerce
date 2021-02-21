class AddCrossSellFieldsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_products, :cross_sell_default, :boolean, :default => false
    add_column :ecommerce_products, :cross_parent_id, :integer
    add_index :ecommerce_products, :cross_parent_id
    add_index :ecommerce_products, :cross_sell_default
  end
end
