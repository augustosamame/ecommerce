class AddDynamicToCoupons < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_coupons, :dynamic, :boolean, default: false
    add_column :ecommerce_coupons, :dynamic_user_id, :integer
  end
end
