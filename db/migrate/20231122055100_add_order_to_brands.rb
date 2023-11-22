class AddOrderToBrands < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_brands, :display_order, :integer
  end
end
