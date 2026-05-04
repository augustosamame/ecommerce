class AddFirstAppPurchaseToEcommerceCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :ecommerce_coupons, :first_app_purchase_active, :boolean, default: false, null: false
    add_column :ecommerce_coupons, :first_app_purchase_message_en, :text
    add_column :ecommerce_coupons, :first_app_purchase_message_es, :text
  end
end
