class AddPointsRedeemedToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_orders, :points_redeemed_amount, :integer
  end
end
