class AddWeightToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_products, :weight, :decimal, precision: 6, scale: 2, default: 0
  end
end
