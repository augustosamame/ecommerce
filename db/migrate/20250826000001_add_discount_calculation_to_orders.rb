class AddDiscountCalculationToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :ecommerce_orders, :discount_calculation, :text
  end
end