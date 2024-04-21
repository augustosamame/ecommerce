class AddInjectProductTwoToComboDiscounts < ActiveRecord::Migration[5.2]
  def change
    
    add_column :ecommerce_combo_discounts, :inject_product_two, :boolean, default: false
  end
end
