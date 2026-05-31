class AddFreeProductIdToEcommerceCoupons < ActiveRecord::Migration[5.2]
  # Lets the `free_product` coupon_type point at the product to be injected
  # into the cart at 1 cent. Nullable since other coupon types don't use it.
  def change
    add_column :ecommerce_coupons, :free_product_id, :bigint
    add_index :ecommerce_coupons, :free_product_id
  end
end
