class ChangeComboDiscountToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :ecommerce_combo_discounts, :discount_amount, :float
  end
end