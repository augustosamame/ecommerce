class AddDiscountPercentageDecimalToCoupons < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_coupons, :discount_percentage_decimal, :decimal, precision: 6, scale: 2
  end
end
