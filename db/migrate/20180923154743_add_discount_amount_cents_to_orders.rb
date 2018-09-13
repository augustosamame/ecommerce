class AddDiscountAmountCentsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_orders, :discount_amount_cents, :integer
  end
end
