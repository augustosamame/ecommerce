class AddCouponIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_products, :coupon_id, :integer
    add_index :ecommerce_products, :coupon_id
  end
end
