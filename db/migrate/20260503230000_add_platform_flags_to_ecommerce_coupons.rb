class AddPlatformFlagsToEcommerceCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :ecommerce_coupons, :web_enabled, :boolean, default: true, null: false
    add_column :ecommerce_coupons, :app_enabled, :boolean, default: true, null: false
  end
end
